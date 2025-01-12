import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/trong/vanphong.dart';
import '../models/trong/ct_khoa.dart';
import '../models/trong/benhvien.dart';
import '../models/trong/bacsi.dart';
import '../models/trong/khoa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingController {
  final String baseUrl;

  BookingController(this.baseUrl);

  Future<List<VanPhong>> getOffices() async {
    final response = await http.get(Uri.parse('$baseUrl/getOffices'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['offices'];
      return data.map((e) => VanPhong.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load offices');
    }
  }

  Future<List<CTKhoa>> getCTKhoa() async {
    final response = await http.get(Uri.parse('$baseUrl/getCTKhoa'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['ctkhoas'];
      return data.map((e) => CTKhoa.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load CTKhoa');
    }
  }

  Future<List<LienKetBenhVien>> getAllCenters() async {
    final response = await http.get(Uri.parse('$baseUrl/getAllCenters'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => LienKetBenhVien.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load centers');
    }
  }

  Future<List<BacSi>> getAllDoctors() async {
    final response = await http.get(Uri.parse('$baseUrl/getAllDoctors'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => BacSi.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<List<Khoa>> getKhoa() async {
    final response = await http.get(Uri.parse('$baseUrl/getKhoa'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['khoas'];
      return data.map((e) => Khoa.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Khoa');
    }
  }

  

  Future<void> datLichKham(int vanphongId, DateTime gioHen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token: $token');
    final userID = prefs.getInt('userID');

    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final url = Uri.parse('$baseUrl/booking');

    // Định dạng đối tượng DateTime thành chuỗi mà máy chủ có thể hiểu được
    final String formattedGioHen = DateFormat('yyyy-MM-ddTHH:mm:ss').format(gioHen);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'user_account_id': userID,
        'vanphong_id': vanphongId,
        'gio_hen': formattedGioHen,
      }),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      print('Đặt lịch khám thành công: ${responseBody["lich_hen_id"]}');
    } else {
      print('Lỗi: ${response.body}');
    }
  }
}
