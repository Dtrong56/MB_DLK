import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trong/appointment.dart';
import '../System/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trong/review.dart';

class AppointmentController {
  Future<AppointmentsList> getUserAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt('userID');
    final response = await http.get(Uri.parse('$apiUrl/appointments/$userID'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['appointments'];
      return AppointmentsList.fromJson(data);
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<void> addReview(Review review) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Assume the JWT token is stored in SharedPreferences

    final response = await http.post(
      Uri.parse('$apiUrl/review'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 201) {
      print('Review added successfully');
    } else {
      throw Exception('Failed to add review: ${response.body}');
    }
  }
}

