class AuthModel {
  final String username;
  final String password;

  AuthModel({
    required this.username,
    required this.password,
  });

  bool isValidCredentials() {
    return username == 'admin' && password == 'admin123';
  }
} 