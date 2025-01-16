import 'package:flutter/material.dart';
import '../models/trong/appointment.dart';
import '../repo/appointment_controller.dart';
import '../screens/review_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListViewForm extends StatefulWidget {
  const ListViewForm({Key? key}) : super(key: key);

  @override
  _ListViewFormState createState() => _ListViewFormState();
}

class _ListViewFormState extends State<ListViewForm> {
  late Future<AppointmentsList> futureAppointments;
  String dropdownValue = 'Đã đặt'; // Giá trị ban đầu của Dropdown

  @override
  void initState() {
    super.initState();
    futureAppointments = AppointmentController().getUserAppointments();
  }

  List<Appointment> _filterAppointments(List<Appointment> appointments) {
    switch (dropdownValue) {
      case 'Đã đặt':
        return appointments.where((appointment) => appointment.trangThai == '0' || appointment.trangThai == '1').toList();
      case 'Hoàn thành':
        return appointments.where((appointment) => appointment.trangThai == '3').toList();
      case 'Hủy':
        return appointments.where((appointment) => appointment.trangThai == '2').toList();
      default:
        return appointments;
    }
  }

  Future<void> _saveDoctorId(int doctorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('doctorID', doctorId);
    int? idluutru = prefs.getInt('doctorID');
    print('ID bác sĩ được lưu là: $idluutru');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Trạng thái:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Đã đặt', 'Hoàn thành', 'Hủy']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<AppointmentsList>(
            future: futureAppointments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.appointments.isEmpty) {
                return Center(child: Text('No Appointments Found'));
              } else {
                final filteredAppointments = _filterAppointments(snapshot.data!.appointments);
                if (filteredAppointments.isEmpty) {
                  return Center(child: Text('No Appointments Found'));
                }
                return ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(filteredAppointments[index]);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(Appointment appointment) {
    String getStatusText(String status) {
      switch (status) {
        case '0':
          return 'Đã đặt';
        case '1':
          return 'Xác nhận';
        case '2':
          return 'Hủy';
        case '3':
          return 'Hoàn thành';
        default:
          return status;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ListTile(
          title: Text('ID: ${appointment.id}', style: Theme.of(context).textTheme.titleLarge),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Văn phòng ID: ${appointment.vanphongId}'),
              Text('Giờ hẹn: ${appointment.gioHen}'),
              Text('Trạng thái: ${getStatusText(appointment.trangThai)}'),
              Text('Ngày giờ đặt: ${appointment.ngayGioDat}'),
              Text('Kiểu đặt: ${appointment.kieuDat}'),
            ],
          ),
          trailing: getStatusText(appointment.trangThai) == 'Hoàn thành'
              ? TextButton(
                  onPressed: () async {
                    // Lưu ID bác sĩ vào SharedPreferences khi nhấn nút Đánh giá
                    await _saveDoctorId(appointment.vanphongId);
                    // Điều hướng tới ReviewPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewPage(),
                      ),
                    );
                  },
                  child: const Text('Đánh giá'),
                )
              : null,
        ),
      ),
    );
  }
}
