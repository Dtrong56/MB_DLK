class User {
  final int id;
  final String username;
  final String password;
  final String ho;
  final String ten;
  final String sdt;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.ho,
    required this.ten,
    required this.sdt,
    required this.email,
  });

  // Phương thức để chuyển đổi từ JSON thành đối tượng User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      ho: json['ho'],
      ten: json['ten'],
      sdt: json['sdt'],
      email: json['email'],
    );
  }

  // Phương thức để chuyển đổi đối tượng User thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'ho': ho,
      'ten': ten,
      'sdt': sdt,
      'email': email,
    };
  }
}
