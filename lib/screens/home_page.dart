import 'package:flutter/material.dart';
import '../components/booking_form.dart'; // Import BookingForm
import '../components/appointments_form.dart'; // Import ListViewForm
import '../screens/user_info_page.dart'; // Import UserInfoPage
import '../repo/user_controller.dart'; // Import UserController
import 'package:shared_preferences/shared_preferences.dart';
import '../components/doctor_form.dart';
import '../components/center_form.dart';

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

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Danh sách bác sĩ';
      case 1:
        return 'Danh sách bệnh viện';
      case 2:
        return 'Đặt lịch khám';
      case 3:
        return 'Lịch khám';
      default:
        return 'Form 1';
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return ListDoctorView();
      case 1:
        return ListHospitalView();
      case 2:
        return BookingForm(); // Hiển thị BookingForm khi chọn Đặt hẹn
      case 3:
        return ListViewForm(); // Hiển thị ListViewForm khi chọn Lịch khám
      default:
        return Center(child: Text('Form 1'));
    }
  }

  void _navigateToUserInfo(BuildContext context) async {
    try {
      final userController = UserController();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userID = prefs.getInt('userID');
      final userData = await userController.getUser(userID!); // Thay số 1 bằng ID người dùng thực tế
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoPage(userData: userData),
        ),
      );
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
        backgroundColor: Colors.blueAccent,
        title: Text(_getAppBarTitle()), // Cập nhật tiêu đề AppBar dựa trên nhãn được chọn
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => _navigateToUserInfo(context),
          ),
        ],
      ),
      body: _buildContent(), // Gọi _buildContent trực tiếp mà không cần Expanded
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Đặt màu nền cụ thể cho BottomNavigationBar
        elevation: 5, // Thêm độ nổi để BottomNavigationBar không bị trong suốt
        type: BottomNavigationBarType.fixed, // Đặt loại fixed để các mục không bị tràn
        selectedItemColor: Colors.blueAccent, // Đặt màu cho mục đã chọn
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Xem bác sĩ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Danh sách bệnh viện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Đặt lịch khám',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Xem lịch khám',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
