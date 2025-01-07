import 'package:flutter/material.dart';
import '../repo/user_controller.dart';
import 'user_info_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return Text('Form 1');
      case 1:
        return Text('Form 2');
      case 2:
        return Text('Form 3');
      default:
        return Text('Form 1');
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _navigateToUserInfo(BuildContext context) async {
    try {
      final userController = UserController();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userid = prefs.getInt('userID');
      final userData = await userController.getUser(userid!); // Thay số 1 bằng ID người dùng thực tế
      _navigateToPage(context, UserInfoPage(userData: userData));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Content Screen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => _navigateToUserInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Form 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two),
            label: 'Form 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3),
            label: 'Form 3',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
