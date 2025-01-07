import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../repo/signup_controller.dart';
import '../models/user.dart'; // Import model User từ file user.dart

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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Log các giá trị đầu vào
      print('Họ: $_ho');
      print('Tên: $_ten');
      print('Số điện thoại: $_sdt');
      print('Email: $_email');
      print('Username: $_username');
      print('Password: $_password');

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
        Navigator.pushReplacementNamed(context, '/login'); // Chuyển đến LoginPage
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
          // Cupertino text field cho trường họ
          CupertinoTextField(
            placeholder: 'Họ: ',
            style: TextStyle(fontFamily: 'NotoSans'),
            onSubmitted: (value) {
              setState(() {
                _ho = value;
              });
            },
          ),
          SizedBox(height: 20),
          // Cupertino text field cho trường tên
          CupertinoTextField(
            placeholder: 'Tên: ',
            style: TextStyle(fontFamily: 'NotoSans'),
            onSubmitted: (value) {
              setState(() {
                _ten = value;
              });
            },
          ),
          SizedBox(height: 20),
          // Cupertino text field cho trường sđt
          CupertinoTextField(
            placeholder: 'Số điện thoại: ',
            style: TextStyle(fontFamily: 'NotoSans'),
            onSubmitted: (value) {
              setState(() {
                _sdt = value;
              });
            },
          ),
          SizedBox(height: 20),
          // Cupertino text field cho trường email
          CupertinoTextField(
            placeholder: 'Email: ',
            style: TextStyle(fontFamily: 'NotoSans'),
            onSubmitted: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          SizedBox(height: 20),
          // Cupertino text field cho trường username
          CupertinoTextField(
            placeholder: 'Username: ',
            style: TextStyle(fontFamily: 'NotoSans'),
            onSubmitted: (value) {
              setState(() {
                _username = value;
              });
            },
          ),
          SizedBox(height: 20),
          // Cupertino text field cho trường password
          CupertinoTextField(
            placeholder: 'Password: ',
            style: TextStyle(fontFamily: 'NotoSans'),
            obscureText: true,
            onSubmitted: (value) {
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
