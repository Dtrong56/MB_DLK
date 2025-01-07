import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class SignupController 
{
  final String apiUrl = "http://192.168.1.45:7777";

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