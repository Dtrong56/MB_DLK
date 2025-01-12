class Khoa {
  final int id;
  final String tenKhoa;

  Khoa({
    required this.id,
    required this.tenKhoa,
  });

  factory Khoa.fromJson(Map<String, dynamic> json) {
    return Khoa(
      id: json['id'],
      tenKhoa: json['ten_khoa'],
    );
  }
}
