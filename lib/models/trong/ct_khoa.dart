class CTKhoa {
  final int id;
  final int bacsiId;
  final int? khoaId;

  CTKhoa({
    required this.id,
    required this.bacsiId,
    this.khoaId,
  });

  factory CTKhoa.fromJson(Map<String, dynamic> json) {
    return CTKhoa(
      id: json['id'],
      bacsiId: json['bacsi_id'],
      khoaId: json['khoa_id'],
    );
  }
}
