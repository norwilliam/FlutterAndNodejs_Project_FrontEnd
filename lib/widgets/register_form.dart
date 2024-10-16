import 'package:flutter/material.dart';
import 'package:flutter_lab1/controller/auth_service.dart';
import 'package:flutter/services.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _NameController = TextEditingController();
  String? _selectedRole;

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      print('Name : ${_NameController.text}');
      print('Username : ${_usernameController.text}');
      print('Password : ${_passwordController.text}');
      print('Role: $_selectedRole');
      try {
        await AuthService().register(_NameController.text,
            _usernameController.text, _passwordController.text, _selectedRole!);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ลงทะเบียนผู้ใช้ใหม่สำเร็จ')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ไม่สามารถลงทะเบียนผู้ใช้ใหม่ได้')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _NameController,
            decoration: const InputDecoration(
              labelText: 'ชื่อ',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกชื่อของคุณ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'นามสกุล',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกนามสกุลของคุณ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'เบอร์โทร',
              prefixIcon: Icon(Icons.phone),
              counterText: '', // ปิดการแสดงผลตัวเลขกำกับ
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // อนุญาตพิมพ์เฉพาะตัวเลข
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกเบอร์โทรของคุณ';
              } else if (value.length != 10) {
                return 'เบอร์โทรต้องมี 10 หลัก';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอก Username ของคุณ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอก Password ของคุณ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            hint: const Text('---โปรดเลือก---'),
            items: ['ผู้ใช้งานทั่วไป', 'เจ้าหน้าที่ผู้ปฏิบัติงาน']
                .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedRole = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณาเลือกตำแหน่งภายในระบบของคุณ';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'ตำแหน่งภายในระบบ',
              prefixIcon: Icon(Icons.group),
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              _register();
              Future.delayed(Duration(seconds: 3), () {
                Navigator.pop(context);
              });
            },
            child: const Text(
              'ลงทะเบียน',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
