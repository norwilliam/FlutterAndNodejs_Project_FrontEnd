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
          SnackBar(content: Text('Failed to add report')),
        );
        Navigator.pop(context, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Report'),
        backgroundColor:
            const Color.fromARGB(255, 90, 1, 255),
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
                  'Add a New Report',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a product name' : null,
                  onSaved: (value) => title = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Details',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a product type' : null,
                  onSaved: (value) => details = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'location',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  //keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                  onSaved: (value) => location = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a unit' : null,
                  onSaved: (value) => status = value,
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
                      'Add Report',
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
