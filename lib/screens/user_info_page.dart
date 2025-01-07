import 'package:flutter/material.dart';
import '../repo/user_controller.dart';

class UserInfoPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  UserInfoPage({required this.userData});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.userData['ho']);
    _lastNameController = TextEditingController(text: widget.userData['ten']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _phoneNumberController = TextEditingController(text: widget.userData['sdt']);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    try {
      final userController = UserController();
      final response = await userController.editUser(
        widget.userData['id'],
        {
          'ho': _firstNameController.text,
          'ten': _lastNameController.text,
          'email': _emailController.text,
          'sdt': _phoneNumberController.text,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User information updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user information: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              SizedBox(height: 16),
              _buildTextField(controller: _firstNameController, labelText: 'First Name'),
              SizedBox(height: 8),
              _buildTextField(controller: _lastNameController, labelText: 'Last Name'),
              SizedBox(height: 8),
              _buildTextField(controller: _emailController, labelText: 'E-Mail Id'),
              SizedBox(height: 8),
              _buildTextField(controller: _phoneNumberController, labelText: 'Phone Number/User Name'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText}) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
      controller: controller,
    );
  }
}
