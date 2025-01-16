import 'package:flutter/foundation.dart';

class Appointment {
  final String gioHen;
  final int id;
  final int kieuDat;
  final String ngayGioDat;
  final String trangThai;
  final int vanphongId;

  Appointment({
    required this.gioHen,
    required this.id,
    required this.kieuDat,
    required this.ngayGioDat,
    required this.trangThai,
    required this.vanphongId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      gioHen: json['gio_hen'],
      id: json['id'],
      kieuDat: json['kieu_dat'],
      ngayGioDat: json['ngay_gio_dat'],
      trangThai: json['trang_thai'],
      vanphongId: json['vanphong_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gio_hen': gioHen,
      'id': id,
      'kieu_dat': kieuDat,
      'ngay_gio_dat': ngayGioDat,
      'trang_thai': trangThai,
      'vanphong_id': vanphongId,
    };
  }
}

class AppointmentsList {
  final List<Appointment> appointments;

  AppointmentsList({required this.appointments});

  factory AppointmentsList.fromJson(List<dynamic> json) {
    List<Appointment> appointments = json.map((i) => Appointment.fromJson(i)).toList();
    return AppointmentsList(appointments: appointments);
  }

  List<dynamic> toJson() {
    return appointments.map((appointment) => appointment.toJson()).toList();
  }
}
