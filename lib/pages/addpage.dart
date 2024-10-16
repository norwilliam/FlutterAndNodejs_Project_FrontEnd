import 'package:flutter/material.dart';
import 'package:flutter_lab1/controller/report_service.dart';
import 'package:flutter_lab1/models/report_model.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? details;
  String? location;
  String? status;
  String? selectedTopic;

  void addReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ReportModel newReport = ReportModel(
        id: '',
        title: title!,
        details: details!,
        location: location!,
        status: status!,
      );

      final response = await ReportService().addReport(context, newReport);
      if (response) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ส่งคำร้องแจ้งซ่อมไม่สำเร็จ')),
        );
        Navigator.pop(context, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          "คำร้องแจ้งซ่อม",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 90, 1, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เพิ่มคำร้องแจ้งซ่อม',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedTopic,
                  hint: const Text('---โปรดเลือก---'),
                  decoration: InputDecoration(
                    labelText: 'หัวข้อ',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'ไฟฟ้า',
                      child: Text('ไฟฟ้า'),
                    ),
                    DropdownMenuItem(
                      value: 'ประปา',
                      child: Text('ประปา'),
                    ),
                    DropdownMenuItem(
                      value: 'อาคาร',
                      child: Text('อาคาร'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedTopic = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'กรุณาเลือกหัวข้อ' : null,
                  onSaved: (value) => title = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'รายละเอียด',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'กรุณากรอกรายละเอียด' : null,
                  onSaved: (value) => details = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'สถานที่',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'กรุณากรอกสถานที่' : null,
                  onSaved: (value) => location = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'สถานะ',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  readOnly: true, // ล็อกไม่ให้กรอกข้อมูล
                  initialValue: 'รอดำเนินการ', // แสดงค่าตายตัว
                  onSaved: (value) =>
                      status = 'รอดำเนินการ', // บันทึกค่าตายตัวนี้
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: addReport,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 0, 30, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'ส่งคำร้องแจ้งซ่อม',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
