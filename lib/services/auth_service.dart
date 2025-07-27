import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/services/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lenat_mobile/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthService {
  final _prefs = SharedPreferences.getInstance();
  final _secureStorage = const FlutterSecureStorage();

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'access_token');
    return token != null;
  }

  Future<bool> isProfileComplete() async {
    final user = await getCurrentUser();
    return user != null && !user.isNewUser;
  }

  Future<String?> getAuthOtp(String email) async {
    try {
      final client = await GraphQLService.getUnauthenticatedClient();
      const query = r'''
        mutation($value: String!) {
          auth_otp(value: $value) {
            message
          }
        }
      ''';

      final result = await client.mutate(
        MutationOptions(
          document: gql(query),
          variables: {'value': email},
        ),
      );

      if (result.hasException) {
        final error = result.exception?.graphqlErrors.first.message ??
            'Failed to send OTP';
        throw Exception(error);
      }

      // Store email for later use
      final prefs = await _prefs;
      await prefs.setString('last_email', email);

      return result.data?['auth_otp']?['message'];
    } catch (e) {
      print('Error sending OTP: $e');
      rethrow;
    }
  }

  Future<UserModel?> handleOtpCallback(String email, String code) async {
    try {
      final client = await GraphQLService.getUnauthenticatedClient();
      const mutation = r'''
        mutation($value: String!, $code: String!) {
          auth_otp_callback(value: $value, code: $code) {
            access_token
            refresh_token
            email
            id
            new_user
            phone_number
            role
            roles
          }
        }
      ''';

      final result = await client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: {
            'value': email,
            'code': code,
          },
        ),
      );

      if (result.hasException) {
        final error = result.exception?.graphqlErrors.first.message ??
            'Failed to verify OTP';
        throw Exception(error);
      }

      final data = result.data?['auth_otp_callback'];
      if (data != null) {
        // Store tokens securely
        await _secureStorage.write(
            key: 'access_token', value: data['access_token']);
        await _secureStorage.write(
            key: 'refresh_token', value: data['refresh_token']);

        // Store basic user data first to avoid circular dependency
        final basicUser = UserModel.fromJson(data);
        await _secureStorage.write(
            key: 'user_data', value: jsonEncode(basicUser.toJson()));

        // Now fetch complete user data
        final completeUser = await fetchCompleteUserData(data['id']);
        print('Complete user: $completeUser');
        if (completeUser != null) {
          print('Complete user: $completeUser');
          return completeUser;
        }

        // Return basic user data if complete fetch fails
        return basicUser;
      }

      return null;
    } catch (e) {
      print('Error verifying OTP: $e');
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final userDataStr = await _secureStorage.read(key: 'user_data');
      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr) as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<UserModel?> fetchCompleteUserData(String userId) async {
    try {
      const query = r'''
        query GetUserData($userId: uuid!) {
          users_by_pk(id: $userId) {
            email
            id
            phone_number
            profile {
              birth_date
              full_name
              gender
              id
              media_id
              media {
                url
                blur_hash
              }
              patient {
                relationship
                pregnancy_period
              }
            }
          }
        }
      ''';

      print('Fetching complete user data for userId: $userId');

      final client = await GraphQLService.getClient();

      // Use the extension method for automatic token refresh
      final result = await client.queryWithTokenRefresh(
        QueryOptions(
          document: gql(query),
          variables: {'userId': userId},
        ),
      );

      print('GraphQL query executed successfully');
      print('Result data: ${result.data}');
      print('Result loading: ${result.isLoading}');

      if (result.hasException) {
        print('GraphQL exception: ${result.exception}');
        print('GraphQL errors: ${result.exception?.graphqlErrors}');
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Failed to fetch user data');
      }

      final userData = result.data?['users_by_pk'];
      print('User data fetched: $userData');

      if (userData == null) {
        print('No user data found for userId: $userId');
        print('Full result data: ${result.data}');
        return null;
      }

      print('Fetched user data: $userData');
      final profile = userData['profile'];
      final media = profile?['media'];
      final patient = profile?['patient'];

      final transformedData = {
        'id': userData['id'],
        'email': userData['email'],
        'phone_number': userData['phone_number'],
        'role': 'user',
        'new_user': false,
        'gender': profile?['gender'],
        'full_name': profile?['full_name'],
        'birth_date': profile?['birth_date'],
        'profile_image': media?['url'],
        'profile_image_blur_hash': media?['blur_hash'],
        'relationship': patient?['relationship'],
        'pregnancy_period': patient?['pregnancy_period'],
        'media': media,
      };

      // Store the complete user data
      await _secureStorage.write(
        key: 'user_data',
        value: jsonEncode(transformedData),
      );

      return UserModel.fromJson(transformedData);
    } catch (e) {
      print('Error fetching complete user data: $e');
      return null;
    }
  }

  Future<void> updateUserProfile({
    required String gender,
    String? profileImage,
    String? fullName,
    String? phoneNumber,
    String? dateOfBirth,
    String? bio,
    String? relationship,
    int? pregnancyPeriod,
  }) async {
    final userDataStr = await _secureStorage.read(key: 'user_data');

    if (userDataStr == null) {
      throw Exception('User data not found');
    }

    // Get existing user data
    final existingUserData = jsonDecode(userDataStr) as Map<String, dynamic>;
    final userId = existingUserData['id'] as String;

    // Combined mutation for both profile and patient updates
    const mutation = r'''
      mutation UpdateProfileFully(
        $userId: uuid!,
        $gender: String!,
        $fullName: String!,
        $dateOfBirth: date!,
        $relationship: enum_parent_relationship_enum,
        $pregnancyPeriod: Int
      ) {
        update_profiles(
          where: {id: {_eq: $userId}},
          _set: {
            gender: $gender,
            full_name: $fullName,
            birth_date: $dateOfBirth
          }
        ) {
          returning {
            birth_date
            full_name
            gender
            id
          }
        }
        update_profile_patients(
          where: {id: {_eq: $userId}},
          _set: {
            relationship: $relationship,
            pregnancy_period: $pregnancyPeriod
          }
        ) {
          returning {
            pregnancy_period
            relationship
          }
        }
      }
    ''';

    final client = await GraphQLService.getClient(role: GraphQLService.roleMe);
    // Use the extension method for automatic token refresh
    final result = await client.mutationWithTokenRefresh(
      MutationOptions(
        document: gql(mutation),
        variables: {
          'userId': userId,
          'gender': gender,
          'fullName': fullName,
          'dateOfBirth': dateOfBirth,
          'relationship': relationship,
          'pregnancyPeriod': pregnancyPeriod,
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception?.graphqlErrors.first.message ??
          'Failed to update profile(updateUserProfile)');
    }

    final profileData = result.data?['update_profiles']?['returning']?[0];
    final patientData =
        result.data?['update_profile_patients']?['returning']?[0];

    if (profileData != null) {
      // Merge profile data with existing user data
      final updatedUserData = {
        ...existingUserData,
        'gender': gender,
        'full_name': fullName,
        'date_of_birth': dateOfBirth,
        'new_user': false,
      };

      // Add patient data if available
      if (patientData != null) {
        updatedUserData['relationship'] = patientData['relationship'];
        updatedUserData['pregnancy_period'] = patientData['pregnancy_period'];
      }

      // Save merged data
      await _secureStorage.write(
        key: 'user_data',
        value: jsonEncode(updatedUserData),
      );
    }
  }

  Future<void> logout() async {
    try {
      // Clear secure storage
      await _secureStorage.deleteAll();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      print('Logout completed - all local data cleared');
    } catch (e) {
      print('Error during logout: $e');
      // Even if there's an error, try to clear as much as possible
      await _secureStorage.deleteAll();
    }
  }

  Future<void> deleteAccount(String userId) async {
    try {
      final client = await GraphQLService.getClient();
      const mutation = r'''
        mutation delete_account {
          delete_users(where: {id: {_eq: $userId}}) {
            affected_rows
          }
        }
      ''';
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProfileUploadUrl(String fileName) async {
    try {
      final client = await GraphQLService.getClient();
      const query = r'''
        query GetProfileUploadUrl($fileName: String!) {
          storage_profile_upload(file_name: $fileName) {
            url
          }
        }
      ''';
      // Use the extension method for automatic token refresh
      final result = await client.queryWithTokenRefresh(
        QueryOptions(
          document: gql(query),
          variables: {'fileName': fileName},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Failed to get upload URL');
      }

      return result.data?['storage_profile_upload'];
    } catch (e) {
      print('Error getting profile upload URL: $e');
      rethrow;
    }
  }
}
