import 'package:flutter/material.dart';
import '../models/trong/review.dart';
import '../repo/appointment_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewTextController = TextEditingController();
  bool _voDanh = false;
  bool _khuyenKhich = true;
  int _waiTimeRating = 3;
  int _danhGiaBs = 4;
  int _danhGiaTong = 5;
  final DateTime _ngay = DateTime.now();
  final AppointmentController _appointmentController = AppointmentController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đánh giá'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _reviewTextController,
                decoration: InputDecoration(
                  labelText: 'Đánh giá của bạn',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống dòng này';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: Text('Thời gian chờ', style: TextStyle(fontSize: 16))),
                  DropdownButton<int>(
                    value: _waiTimeRating,
                    onChanged: (newValue) {
                      setState(() {
                        _waiTimeRating = newValue!;
                      });
                    },
                    items: List.generate(5, (index) => index + 1)
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value.toString()),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: Text('Đánh giá bác sĩ', style: TextStyle(fontSize: 16))),
                  DropdownButton<int>(
                    value: _danhGiaBs,
                    onChanged: (newValue) {
                      setState(() {
                        _danhGiaBs = newValue!;
                      });
                    },
                    items: List.generate(5, (index) => index + 1)
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value.toString()),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: Text('Đánh giá tổng thể', style: TextStyle(fontSize: 16))),
                  DropdownButton<int>(
                    value: _danhGiaTong,
                    onChanged: (newValue) {
                      setState(() {
                        _danhGiaTong = newValue!;
                      });
                    },
                    items: List.generate(5, (index) => index + 1)
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value.toString()),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              SwitchListTile(
                title: Text('Ẩn danh'),
                value: _voDanh,
                onChanged: (newValue) {
                  setState(() {
                    _voDanh = newValue;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Khuyến khích'),
                value: _khuyenKhich,
                onChanged: (newValue) {
                  setState(() {
                    _khuyenKhich = newValue;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  final userID = prefs.getInt('userID');
                  final bacsiID = prefs.getInt('doctorID');
                  if (userID != null && bacsiID != null) { // Check if userID and doctorID are not null
                    if (_formKey.currentState?.validate() ?? false) {
                      // Gửi đánh giá
                      final review = Review(
                        userAccountId: userID, // Thay bằng ID tài khoản người dùng thực tế
                        bacSiId: bacsiID, // Thay bằng ID bác sĩ thực tế
                        voDanh: _voDanh,
                        waiTimeRating: _waiTimeRating,
                        danhGiaBs: _danhGiaBs,
                        danhGiaTong: _danhGiaTong,
                        reviewText: _reviewTextController.text,
                        khuyenKhich: _khuyenKhich,
                        ngay: _ngay,
                      );
                      try {
                        await _appointmentController.addReview(review);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đánh giá đã được gửi thành công')));
                        Navigator.pop(context); // Quay lại trang trước đó
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gửi đánh giá thất bại: $e')));
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không tìm thấy userID hoặc doctorID')));
                  }
                },
                child: Text('Gửi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
