class UserModel {
  final String id;
  final String email;
  final String? phoneNumber;
  final String role;
  final bool isNewUser;
  final String? gender;
  final String? profileImage;
  final String? fullName;
  final String? dateOfBirth;
  final String? bio;
  final String? relationship;
  final int? pregnancyPeriod;

  UserModel({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.isNewUser,
    this.gender,
    this.profileImage,
    this.fullName,
    this.dateOfBirth,
    this.bio,
    this.relationship,
    this.pregnancyPeriod,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      role: json['role'] as String,
      isNewUser: json['new_user'] as bool,
      gender: json['gender'] as String?,
      profileImage: json['profile_image'] as String?,
      fullName: json['full_name'] as String?,
      dateOfBirth: json['birth_date'] as String?,
      bio: json['bio'] as String?,
      relationship: json['relationship'] as String?,
      pregnancyPeriod: json['pregnancy_period'] as int?,
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
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'bio': bio,
      'relationship': relationship,
      'pregnancy_period': pregnancyPeriod,
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
    String? fullName,
    String? dateOfBirth,
    String? bio,
    String? relationship,
    int? pregnancyPeriod,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      isNewUser: isNewUser ?? this.isNewUser,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bio: bio ?? this.bio,
      relationship: relationship ?? this.relationship,
      pregnancyPeriod: pregnancyPeriod ?? this.pregnancyPeriod,
    );
  }
}
