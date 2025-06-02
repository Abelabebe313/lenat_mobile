class UserModel {
  final String id;
  final String email;
  final String? phoneNumber;
  final String role;
  final List<String> roles;
  final bool isNewUser;
  final String? gender;
  final String? profileImage;
  final String? fullName;
  final String? dateOfBirth;
  final String? bio;

  UserModel({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.roles,
    required this.isNewUser,
    this.gender,
    this.profileImage,
    this.fullName,
    this.dateOfBirth,
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      role: json['role'] as String,
      roles: List<String>.from(json['roles'] as List),
      isNewUser: json['new_user'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'roles': roles,
      'new_user': isNewUser,
      'gender': gender,
      'profile_image': profileImage,
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'bio': bio,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? role,
    List<String>? roles,
    bool? isNewUser,
    String? gender,
    String? profileImage,
    String? fullName,
    String? dateOfBirth,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      roles: roles ?? this.roles,
      isNewUser: isNewUser ?? this.isNewUser,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bio: bio ?? this.bio,
    );
  }
}
