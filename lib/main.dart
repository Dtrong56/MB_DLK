import 'package:flutter/material.dart';
import 'screens/login_page.dart'; // Import trang đăng nhập
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: Locale('vi', 'VN'), // Đặt locale là Tiếng Việt 
      supportedLocales: [ Locale('en', 'US'), // Locale cho Tiếng Anh 
      Locale('vi', 'VN'), // Locale cho Tiếng Việt 
      ], 
      localizationsDelegates: [ 
        GlobalMaterialLocalizations.delegate, 
        GlobalWidgetsLocalizations.delegate, 
        GlobalCupertinoLocalizations.delegate,
      ],
      home: LoginPage(), // Điều hướng tới trang đăng nhập
    );
  }
}

