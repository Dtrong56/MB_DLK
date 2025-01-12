class LienKetBenhVien {
  final int id;
  final int bacSiId;
  final String tenBenhVien;
  final String diaChi;
  final DateTime ngayDb;
  final DateTime? ngayKt;

  LienKetBenhVien({
    required this.id,
    required this.bacSiId,
    required this.tenBenhVien,
    required this.diaChi,
    required this.ngayDb,
    this.ngayKt,
  });

  factory LienKetBenhVien.fromJson(Map<String, dynamic> json) {
    return LienKetBenhVien(
      id: json['id'],
      bacSiId: json['bac_si_id'],
      tenBenhVien: json['ten_benh_vien'],
      diaChi: json['dia_chi'],
      ngayDb: DateTime.parse(json['ngay_db']),
      ngayKt: json['ngay_kt'] != null ? DateTime.parse(json['ngay_kt']) : null,
    );
  }
}
