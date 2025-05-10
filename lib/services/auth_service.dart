class AuthService {
  // Mock control flags
  final bool _mockLoggedIn = false;
  final bool _mockProfileComplete = true;

  /// Simulates checking if the user is logged in
  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate delay
    return _mockLoggedIn;
  }

  /// Simulates checking if the user's profile is complete
  Future<bool> isProfileComplete() async {
    await Future.delayed(const Duration(milliseconds: 200)); // simulate delay
    return _mockProfileComplete;
  }
}
