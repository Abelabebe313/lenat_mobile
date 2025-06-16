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

        // Fetch complete user data
        final completeUser = await fetchCompleteUserData(data['id']);
        if (completeUser != null) {
          return completeUser;
        }

        // Fallback to basic user data if complete fetch fails
        final user = UserModel.fromJson(data);
        await _secureStorage.write(
            key: 'user_data', value: jsonEncode(user.toJson()));
        return user;
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
      final client = await GraphQLService.getClient();
      const query = r'''
        query GetUserData($userId: uuid!) {
          users_by_pk(id: $userId) {
            email
            id
            phone_number
            status
            updated_at
            auth_provider
            profile {
              birth_date
              full_name
              gender
              id
            }
          }
        }
      ''';

      final result = await client.query(
        QueryOptions(
          document: gql(query),
          variables: {'userId': userId},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Failed to fetch user data');
      }

      final userData = result.data?['users_by_pk'];
      if (userData != null) {
        // Transform the data to match UserModel format
        final transformedData = {
          'id': userData['id'],
          'email': userData['email'],
          'phone_number': userData['phone_number'],
          'role': 'user', // Default role
          'new_user':
              false, // Default to false since we're fetching existing user
          'gender': userData['profile']?['gender'],
          'full_name': userData['profile']?['full_name'],
          'birth_date': userData['profile']?['birth_date'],
        };

        // Store the complete user data
        await _secureStorage.write(
            key: 'user_data', value: jsonEncode(transformedData));

        return UserModel.fromJson(transformedData);
      }
      return null;
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
    try {
      final client =
          await GraphQLService.getClient(role: GraphQLService.roleMe);
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

      final result = await client.mutate(
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
            'Failed to update profile');
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
            key: 'user_data', value: jsonEncode(updatedUserData));
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<String?> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final client = await GraphQLService.getUnauthenticatedClient();
      const mutation = r'''
        mutation($refresh_token: String!) {
          auth_refresh_tokens(refresh_token: $refresh_token) {
            access_token
            refresh_token
          }
        }
      ''';

      final result = await client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: {'refresh_token': refreshToken},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Failed to refresh token');
      }

      final data = result.data?['refresh_token'];
      if (data != null) {
        await _secureStorage.write(
            key: 'access_token', value: data['access_token']);
        await _secureStorage.write(
            key: 'refresh_token', value: data['refresh_token']);
        return data['access_token'];
      }

      return null;
    } catch (e) {
      print('Error refreshing token: $e');
      rethrow;
    }
  }

  Future<String?> getGoogleAuthUrl() async {
    final client = await GraphQLService.getClient();
    const query = r'''
      mutation {
        auth_google(redirect_uri: "com.example.lenat_mobile:/oauth2redirect") {
          url
        }
      }
    ''';

    final result = await client.mutate(MutationOptions(document: gql(query)));
    return result.data?['auth_google']?['url'];
  }

  Future<Map<String, dynamic>?> handleGoogleCallback(String code) async {
    final client = await GraphQLService.getClient();
    final mutation = r'''
      mutation($code: String!) {
        auth_google_callback(code: $code) {
          access_token
          refresh_token
          new_user
          role
          roles
          phone_number
          id
          email
        }
      }
    ''';

    final result = await client.mutate(MutationOptions(
      document: gql(mutation),
      variables: {'code': code},
    ));

    final data = result.data?['auth_google_callback'];
    if (data != null) {
      // Store tokens securely
      await _secureStorage.write(
          key: 'access_token', value: data['access_token']);
      await _secureStorage.write(
          key: 'refresh_token', value: data['refresh_token']);

      // Fetch complete user data
      final completeUser = await fetchCompleteUserData(data['id']);
      if (completeUser != null) {
        return {
          ...data,
          'complete_user': completeUser.toJson(),
        };
      }
    }

    return data;
  }

  Future<Map<String, dynamic>?> startTelegramAuth(String phone) async {
    final client = await GraphQLService.getClient();

    const mutation = r'''
    mutation($phone: String!) {
      auth_telegram(phone: $phone) {
        ssid
        tsession
      }
    }
  ''';

    final result = await client.mutate(MutationOptions(
      document: gql(mutation),
      variables: {
        'phone': phone,
      },
    ));

    return result.data?['auth_telegram'];
  }

  Future<Map<String, dynamic>?> completeTelegramAuth(
      String ssid, String tsession) async {
    final client = await GraphQLService.getClient();

    const mutation = r'''
    mutation($ssid: String!, $tsession: String!) {
      auth_telegram_callback(ssid: $ssid, tsession: $tsession) {
        access_token
        refresh_token
        new_user
        role
        roles
        id
        email
      }
    }
  ''';

    final result = await client.mutate(MutationOptions(
      document: gql(mutation),
      variables: {
        'ssid': ssid,
        'tsession': tsession,
      },
    ));

    final data = result.data?['auth_telegram_callback'];
    if (data != null) {
      // Store tokens securely
      await _secureStorage.write(
          key: 'access_token', value: data['access_token']);
      await _secureStorage.write(
          key: 'refresh_token', value: data['refresh_token']);

      // Fetch complete user data
      final completeUser = await fetchCompleteUserData(data['id']);
      if (completeUser != null) {
        return {
          ...data,
          'complete_user': completeUser.toJson(),
        };
      }
    }

    return data;
  }

  Future<void> logout() async {
    await _secureStorage.deleteAll();
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

      final result = await client.query(
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
