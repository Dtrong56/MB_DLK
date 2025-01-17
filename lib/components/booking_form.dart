import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../System/variable.dart';
import 'package:intl/intl.dart'; // Import thêm để format ngày
import '../repo/book_controller.dart';
import '../models/trong/vanphong.dart';
import '../models/trong/ct_khoa.dart';
import '../models/trong/benhvien.dart';
import '../models/trong/bacsi.dart';
import '../models/trong/khoa.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBenhVien;
  String? _selectedKhoa;
  String? _selectedBacSi;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<VanPhong> _offices = [];
  List<CTKhoa> _ctKhoas = [];
  List<LienKetBenhVien> _centers = [];
  List<BacSi> _allDoctors = [];
  List<BacSi> _doctors = [];
  List<Khoa> _khoas = [];

  final BookingController _controller = BookingController('$apiUrl');

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final offices = await _controller.getOffices();
      final ctKhoas = await _controller.getCTKhoa();
      final centers = await _controller.getAllCenters();
      final doctors = await _controller.getAllDoctors();
      final khoas = await _controller.getKhoa();
      setState(() {
        _offices = offices;
        _ctKhoas = ctKhoas;
        _centers = centers;
        _allDoctors = doctors;
        _doctors = doctors; // Hiển thị danh sách bác sĩ đầy đủ ban đầu
        _khoas = khoas;
      });
    } catch (e) {
      // Handle errors here
      print(e);
    }
  }

  void _updateDoctors() {
    List<BacSi> filteredDoctors = _allDoctors;
    bool hasBenhVienFilter = _selectedBenhVien != null;
    bool hasKhoaFilter = _selectedKhoa != null;

    if (hasBenhVienFilter) {
      filteredDoctors = filteredDoctors.where((doctor) =>
        _centers.any((center) =>
          center.tenBenhVien == _selectedBenhVien && center.bacSiId == doctor.id
        )
      ).toList();
    }

    if (hasKhoaFilter) {
      filteredDoctors = filteredDoctors.where((doctor) =>
        _ctKhoas.any((ctKhoa) =>
          ctKhoa.khoaId == _khoas.firstWhere((khoa) => khoa.tenKhoa == _selectedKhoa).id && ctKhoa.bacsiId == doctor.id
        )
      ).toList();
    }

    if ((hasBenhVienFilter || hasKhoaFilter) && filteredDoctors.isEmpty) {
      filteredDoctors = [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy bác sĩ phù hợp với lựa chọn!'))
      );
    }

    setState(() {
      _doctors = filteredDoctors;
      _selectedBacSi = null; // Đặt lại bác sĩ đã chọn
    });
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  VanPhong? _getOffice() {
    return _offices.firstWhereOrNull((office) =>
        office.bacSiId == _allDoctors.firstWhere((doctor) => doctor.ten == _selectedBacSi).id &&
        office.lienketbenhvienId == _centers.firstWhere((center) => center.tenBenhVien == _selectedBenhVien).id
    );
  }

  Future<void> _bookAppointment() async {
  if (_formKey.currentState!.validate()) {
    final selectedDateAndTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final selectedOffice = _getOffice();

    if (selectedOffice != null) {
      try {
        await _controller.datLichKham(selectedOffice.id, selectedDateAndTime);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đặt lịch khám thành công! Văn phòng: ${selectedOffice.id}')),
        );

        // Reset the form and clear the selected values
        _formKey.currentState!.reset();
        setState(() {
          _selectedBenhVien = null;
          _selectedKhoa = null;
          _selectedBacSi = null;
          _selectedDate = null;
          _selectedTime = null;
          _doctors.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi đặt lịch khám: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy văn phòng phù hợp.')),
      );
    }
  }
}


  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'Đặt lịch khám',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: _selectedBenhVien,
                  decoration: InputDecoration(labelText: 'Bệnh viện'),
                  items: _centers.map((LienKetBenhVien value) {
                    return DropdownMenuItem<String>(
                      value: value.tenBenhVien,
                      child: Text(value.tenBenhVien),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBenhVien = newValue;
                      _updateDoctors(); // Cập nhật danh sách bác sĩ
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn Bệnh viện';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedKhoa,
                  decoration: InputDecoration(labelText: 'Khoa'),
                  items: _khoas.map((Khoa value) {
                    return DropdownMenuItem<String>(
                      value: value.tenKhoa,
                      child: Text(value.tenKhoa),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedKhoa = newValue;
                      _updateDoctors(); // Cập nhật danh sách bác sĩ
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn Khoa';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedBacSi,
                  decoration: InputDecoration(labelText: 'Bác sĩ'),
                  items: _doctors.isNotEmpty
                      ? _doctors.map((BacSi value) {
                          return DropdownMenuItem<String>(
                            value: value.ten,
                            child: Text(value.ten),
                          );
                        }).toList()
                      : [], // Hiển thị danh sách bác sĩ rỗng nếu _doctors rỗng
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBacSi = newValue;
                    });
                  },
                  validator: (value) {
                    if (_doctors.isEmpty) {
                      return 'Không có bác sĩ phù hợp yêu cầu!';
                    }
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn Bác sĩ';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: _selectedDate == null
                            ? 'Chọn ngày'
                            : 'Ngày: ${_selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : ''}',
                      ),
                      validator: (value) {
                        if (_selectedDate == null) {
                          return 'Vui lòng chọn ngày';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: _selectedTime == null
                            ? 'Chọn giờ'
                            : 'Giờ: ${_selectedTime?.format(context)}',
                      ),
                      validator: (value) {
                        if (_selectedTime == null) {
                          return 'Vui lòng chọn giờ';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Thực hiện hành động khi dữ liệu biểu mẫu hợp lệ
                      final selectedDateAndTime = DateTime(
                        _selectedDate!.year,
                        _selectedDate!.month,
                        _selectedDate!.day,
                        _selectedTime!.hour,
                        _selectedTime!.minute,
                      );

                      // Lấy văn phòng theo bệnh viện và bác sĩ đã chọn
                      final selectedOffice = _getOffice();

                      _bookAppointment();
                    }
                  },
                  child: Text('Đặt Lịch Khám'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
