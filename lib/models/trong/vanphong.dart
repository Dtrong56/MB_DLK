class VanPhong {
  final int id;
  final int bacSiId;
  final int? lienketbenhvienId;

  VanPhong({
    required this.id,
    required this.bacSiId,
    this.lienketbenhvienId,
  });

  factory VanPhong.fromJson(Map<String, dynamic> json) {
    return VanPhong(
      id: json['id'],
      bacSiId: json['bac_si_id'],
      lienketbenhvienId: json['lienketbenhvien_id'],
    );
  }
}
