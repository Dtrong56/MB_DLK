  class BacSi {
    final int id;
    final String hocHam;
    final String ho;
    final String ten;
    final String hinhAnh;
    final String moTa;
    final String ngayBdHanhY;
    final String username;

    BacSi({
      required this.id,
      required this.hocHam,
      required this.ho,
      required this.ten,
      required this.hinhAnh,
      required this.moTa,
      required this.ngayBdHanhY,
      required this.username,
    });

    factory BacSi.fromJson(Map<String, dynamic> json) {
      return BacSi(
        id: json['id'] ?? 0,
        hocHam: json['hoc_ham'] ?? '',
        ho: json['ho'] ?? '',
        ten: json['ten'] ?? '',
        hinhAnh: json['hinh_anh'] ?? '',
        moTa: json['mo_ta'] ?? '',
        ngayBdHanhY: json['ngay_bd_hanh_y'] ?? '',
        username: json['username'] ?? '',
      );
    }
  }
