import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../repo/signup_controller.dart';
import '../models/user.dart'; // Import model User từ file user.dart
import '../screens/login_page.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final SignupController signupController = SignupController();

  String _ho = '';
  String _ten = '';
  String _sdt = '';
  String _email = '';
  String _username = '';
  String _password = '';

  String? _validateName(String? value) {
    final validCharacters = RegExp(r'^[a-zA-Z]+$');
    if (value == null || !validCharacters.hasMatch(value)) {
      return 'Họ và tên không được chứa ký tự đặc biệt.';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final validCharacters = RegExp(r'^[0-9]+$');
    if (value == null || !validCharacters.hasMatch(value) || value.length != 10) {
      return 'Số điện thoại không được chứa ký tự đặc biệt và phải đúng 10 ký tự.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || !value.endsWith('@gmail.com')) {
      return 'Email phải có đuôi @gmail.com.';
    }
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      User newUser = User(
        id: 0,
        username: _username,
        password: _password,
        ho: _ho,
        ten: _ten,
        sdt: _sdt,
        email: _email,
      );

      try {
        final response = await signupController.register(newUser);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thành công!'),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false, // Điều này sẽ loại bỏ tất cả các trang trước đó
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thất bại: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Họ',
            ),
            onChanged: (value) {
              setState(() {
                _ho = value;
              });
            },
            validator: _validateName,
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Tên',
            ),
            onChanged: (value) {
              setState(() {
                _ten = value;
              });
            },
            validator: _validateName,
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Số điện thoại',
            ),
            onChanged: (value) {
              setState(() {
                _sdt = value;
              });
            },
            validator: _validatePhoneNumber,
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
            validator: _validateEmail,
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
            ),
            onChanged: (value) {
              setState(() {
                _username = value;
              });
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
          SizedBox(height: 20),
          CupertinoButton.filled(
            onPressed: _register,
            child: Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

