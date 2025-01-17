import 'dart:convert';
import 'package:http/http.dart' as http;
import '../System/variable.dart';
import '../models/trong/bacsi.dart';

class BacsiController {

  static Future<List<BacSi>> getAllDoctors() async {
    final response = await http.get(Uri.parse('$apiUrl/getAllDoctors'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((doctor) => BacSi.fromJson(doctor)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }
}
