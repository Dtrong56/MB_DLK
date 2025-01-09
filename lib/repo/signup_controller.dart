import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../System/variable.dart';

class SignupController 
{

  Future <Map<String,dynamic>> register(User user) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      throw Exception('Đăng ký không thành công: ${jsonDecode(response.body)['msg']}');
    }
  }
}