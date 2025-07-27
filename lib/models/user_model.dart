class UserModel {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String role;
  final bool isNewUser;
  final String? gender;
  final String? profileImage;
  final String? profileImageBlurHash;
  final String? fullName;
  final String? dateOfBirth;
  final String? relationship;
  final int? pregnancyPeriod;
  final Map<String, dynamic>? media;

  UserModel({
    required this.id,
    this.email,
    this.phoneNumber,
    required this.role,
    required this.isNewUser,
    this.gender,
    this.profileImage,
    this.profileImageBlurHash,
    this.fullName,
    this.dateOfBirth,
    this.relationship,
    this.pregnancyPeriod,
    this.media,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      role: json['role'] as String,
      isNewUser: json['new_user'] as bool,
      gender: json['gender'] as String?,
      profileImage: json['profile_image'] as String?,
      profileImageBlurHash: json['profile_image_blur_hash'] as String?,
      fullName: json['full_name'] as String?,
      dateOfBirth: json['birth_date'] as String?,
      relationship: json['relationship'] as String?,
      pregnancyPeriod: json['pregnancy_period'] as int?,
      media: json['media'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'new_user': isNewUser,
      'gender': gender,
      'profile_image': profileImage,
      'profile_image_blur_hash': profileImageBlurHash,
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'relationship': relationship,
      'pregnancy_period': pregnancyPeriod,
      'media': media,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? role,
    bool? isNewUser,
    String? gender,
    String? profileImage,
    String? profileImageBlurHash,
    String? fullName,
    String? dateOfBirth,
    String? bio,
    String? relationship,
    int? pregnancyPeriod,
    Map<String, dynamic>? media,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      isNewUser: isNewUser ?? this.isNewUser,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      profileImageBlurHash: profileImageBlurHash ?? this.profileImageBlurHash,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      relationship: relationship ?? this.relationship,
      pregnancyPeriod: pregnancyPeriod ?? this.pregnancyPeriod,
      media: media ?? this.media,
    );
  }
}
