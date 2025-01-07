import 'package:flutter/material.dart';
import 'package:mb_dlk/screens/signup_page.dart';
import '../repo/login_controller.dart';
import '../screens/home_page.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _loginController = LoginController();
  String _username = '';
  String _password = '';

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
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
            onSaved: (value) {
              _username = value!;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save(); // Lưu trữ các giá trị từ các trường nhập liệu
                print('Username: $_username'); // Log giá trị username
                print('Password: $_password'); // Log giá trị password
                
                final result = await _loginController.login(_username, _password);

                if (result['success']) {
                  // Điều hướng tới trang chủ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                } else {
                  // Hiển thị thông báo lỗi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['msg'])),
                  );
                }
              }
            },
            child: Text('Login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              // Điều hướng tới SignupPage khi nhấn nút
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupPage(),
                ),
              );
            },
            child: Text('Sign Up'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
