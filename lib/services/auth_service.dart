import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/services/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lenat_mobile/models/user_model.dart';

class AuthService {
  final _prefs = SharedPreferences.getInstance();

  // Remove mock flags since we're using real data now
  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getString('access_token') != null;
  }

  Future<bool> isProfileComplete() async {
    final user = await getCurrentUser();
    return user != null && !user.isNewUser;
  }

  Future<String?> getAuthOtp(String email) async {
    try {
      // Use unauthenticated client for OTP request
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
      // Use unauthenticated client for OTP verification
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
        // Create user model
        final user = UserModel.fromJson(data);

        // Store tokens and user data
        final prefs = await _prefs;
        await prefs.setString('access_token', data['access_token']);
        await prefs.setString('refresh_token', data['refresh_token']);
        await prefs.setString('user_data', user.toJson().toString());

        return user;
      }

      return null;
    } catch (e) {
      print('Error verifying OTP: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    required String gender,
    String? profileImage,
    String? fullName,
    String? dateOfBirth,
    String? bio,
  }) async {
    try {
      final client = await GraphQLService.getClient();
      const mutation = r'''
        mutation($gender: String!, $profileImage: String, $fullName: String, $dateOfBirth: String, $bio: String) {
          update_user_profile(
            gender: $gender,
            profile_image: $profileImage,
            full_name: $fullName,
            date_of_birth: $dateOfBirth,
            bio: $bio
          ) {
            id
            gender
            profile_image
            full_name
            date_of_birth
            bio
            new_user
          }
        }
      ''';

      final result = await client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: {
            'gender': gender,
            'profileImage': profileImage,
            'fullName': fullName,
            'dateOfBirth': dateOfBirth,
            'bio': bio,
          },
        ),
      );

      if (result.hasException) {
        final error = result.exception?.graphqlErrors.first.message ??
            'Failed to update profile';
        throw Exception(error);
      }

      final data = result.data?['update_user_profile'];
      if (data != null) {
        final prefs = await _prefs;
        final userDataStr = prefs.getString('user_data');
        if (userDataStr != null) {
          final userData = Map<String, dynamic>.from(
            Map<String, dynamic>.from(userDataStr as Map),
          );
          final updatedUser = UserModel.fromJson(userData).copyWith(
            gender: gender,
            profileImage: profileImage,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            bio: bio,
            isNewUser: false,
          );
          await prefs.setString('user_data', updatedUser.toJson().toString());
        }
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await _prefs;
      final userDataStr = prefs.getString('user_data');
      if (userDataStr != null) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(userDataStr as Map),
        );
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
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

    return result.data?['auth_google_callback'];
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

    return result.data?['auth_telegram_callback'];
  }
}
