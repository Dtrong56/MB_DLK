import 'package:flutter/material.dart';
import '../models/trong/bacsi.dart';
import '../repo/doctor_controller.dart';

class ListDoctorView extends StatefulWidget {
  const ListDoctorView({Key? key}) : super(key: key);

  @override
  _ListDoctorFormState createState() => _ListDoctorFormState();
}

class _ListDoctorFormState extends State<ListDoctorView> {
  late Future<List<BacSi>> futureBacsi;

  @override
  void initState() {
    super.initState();
    futureBacsi = BacsiController.getAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FutureBuilder<List<BacSi>>(
            future: futureBacsi,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có bác sĩ nào được tìm thấy'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(snapshot.data![index]);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BacSi doctor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(doctor.hinhAnh),
            radius: 30,
          ),
          title: Text(
            '${doctor.ho} ${doctor.ten}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Học hàm: ${doctor.hocHam}'),
              Text('Mô tả: ${doctor.moTa}'),
              Text('Ngày bắt đầu hành nghề: ${doctor.ngayBdHanhY}'),
              Text('Username: ${doctor.username}'),
            ],
          ),
        ),
      ),
    );
  }
}


