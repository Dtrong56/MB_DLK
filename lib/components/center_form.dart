import 'package:flutter/material.dart';
import '../models/trong/benhvien.dart';
import '../repo/book_controller.dart';
import '../System/variable.dart';

class ListHospitalView extends StatefulWidget {
  const ListHospitalView({Key? key}) : super(key: key);

  @override
  _ListHospitalFormState createState() => _ListHospitalFormState();
}

class _ListHospitalFormState extends State<ListHospitalView> {
  late Future<List<LienKetBenhVien>> futureHospital;
  BookingController bookingController = new BookingController('$apiUrl');

  @override
  void initState() {
    super.initState();
    futureHospital = bookingController.getAllCenters();
  }

  List<Map<String, dynamic>> toHospital(List<LienKetBenhVien> list) {
    // Sử dụng Map để lưu trữ tần suất xuất hiện của từng cặp tenBenhVien và diaChi
    Map<String, int> frequencyMap = {};

    for (LienKetBenhVien lk in list) {
      String key = '${lk.tenBenhVien}-${lk.diaChi}';
      if (frequencyMap.containsKey(key)) {
        frequencyMap[key] = frequencyMap[key]! + 1;
      } else {
        frequencyMap[key] = 1;
      }
    }

    // Chuyển đổi Map thành danh sách các dict
    List<Map<String, dynamic>> listdict = frequencyMap.entries.map((entry) {
      List<String> keys = entry.key.split('-');
      return {
        'tenBenhVien': keys[0],
        'diaChi': keys[1],
        'lặp': entry.value,
      };
    }).toList();

    return listdict;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FutureBuilder<List<LienKetBenhVien>>(
            future: futureHospital,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có bệnh viện nào được tìm thấy'));
              } else {
                List<Map<String, dynamic>> listdict = toHospital(snapshot.data!);
                return ListView.builder(
                  itemCount: listdict.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(listdict[index]);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(Map<String, dynamic> hospital) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ListTile(          
          title: Text(
            hospital['tenBenhVien'],
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Địa chỉ: ${hospital['diaChi']}'),
              Text('Số bác sĩ: ${hospital['lặp']}'),
            ],
          ),
        ),
      ),
    );
  }
}
