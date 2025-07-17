class User {
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;

  User({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'User{fullName: $fullName, username: $username, email: $email, phoneNumber: $phoneNumber}';
  }
}
