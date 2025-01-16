class Review {
  final int userAccountId;
  final int bacSiId;
  final bool voDanh;
  final int waiTimeRating;
  final int danhGiaBs;
  final int danhGiaTong;
  final String? reviewText;
  final bool khuyenKhich;
  final DateTime ngay;

  Review({
    required this.userAccountId,
    required this.bacSiId,
    required this.voDanh,
    required this.waiTimeRating,
    required this.danhGiaBs,
    required this.danhGiaTong,
    this.reviewText,
    required this.khuyenKhich,
    required this.ngay,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_account_id': userAccountId,
      'bac_si_id': bacSiId,
      'vo_danh': voDanh,
      'wai_time_rating': waiTimeRating,
      'danh_gia_bs': danhGiaBs,
      'danh_gia_tong': danhGiaTong,
      'review': reviewText,
      'khuyen_khich': khuyenKhich,
      'ngay': ngay.toIso8601String(),
    };
  }
}
