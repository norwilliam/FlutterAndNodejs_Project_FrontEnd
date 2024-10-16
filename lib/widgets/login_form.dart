import 'package:flutter/material.dart';
import 'package:flutter_lab1/controller/auth_service.dart';
import 'package:flutter_lab1/models/user_model.dart';
import 'package:flutter_lab1/providers/user_providers.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final userName = _usernameController.text;
      final password = _passwordController.text;

      try {
        final UserModel? userModel =
            await AuthService().login(userName, password);

        if (userModel != null) {
          final String role = userModel.user.role;
          Provider.of<UserProvider>(context, listen: false).onLogin(userModel);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เข้าสู่ระบบในตำแหน่ง$role')),
          );

          if (role == 'เจ้าหน้าที่ผู้ปฏิบัติงาน') {
            Navigator.pushReplacementNamed(context, '/homeadmin');
          } else if (role == 'ผู้ใช้งานทั่วไป') {
            Navigator.pushReplacementNamed(context, '/homeuser');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ตำแหน่งไม่ถูกต้อง: $role')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เข้าสู่ระบบล้มเหลว: User model is null')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เข้าสู่ระบบล้มเหลว: $e')),
        );
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
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _login,
            child: const Text(
              'เข้าสู่ระบบ',
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
