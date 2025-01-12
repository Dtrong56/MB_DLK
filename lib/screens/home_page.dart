import 'package:flutter/material.dart';
import '../components/booking_form.dart'; // Import BookingForm

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
        return 'Form 1';
      case 1:
        return 'Form 2';
      case 2:
        return '';
      case 3:
        return 'Form 4';
      default:
        return 'Form 1';
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return Text('Form 1');
      case 1:
        return Text('Form 2');
      case 2:
        return BookingForm(); // Hiển thị BookingForm khi chọn Đặt hẹn
      case 3:
        return Text('Form 4');
      default:
        return Text('Form 1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(_getAppBarTitle()), // Cập nhật tiêu đề AppBar dựa trên nhãn được chọn
      ),
      body: Column(
        children: [
          _buildContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Đặt màu nền cụ thể cho BottomNavigationBar
        elevation: 5, // Thêm độ nổi để BottomNavigationBar không bị trong suốt
        type: BottomNavigationBarType.fixed, // Đặt loại fixed để các mục không bị tràn
        selectedItemColor: Colors.blueAccent, // Đặt màu cho mục đã chọn
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
            icon: Icon(Icons.calendar_today),
            label: 'Đặt lịch khám',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_4),
            label: 'Form 4',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
