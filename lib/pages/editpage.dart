import 'package:flutter/material.dart';
import 'package:flutter_lab1/controller/report_service.dart';
import 'package:flutter_lab1/models/report_model.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.report}) : super(key: key);
  final ReportModel report;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String details;
  late String location;
  late String status;

  @override
  void initState() {
    super.initState();
    title = widget.report.title;
    details = widget.report.details;
    location = widget.report.location;
    status = widget.report.status;
  }

  Future<void> _updateReport() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedReport = ReportModel(
        id: widget.report.id,
        title: title,
        details: details,
        location: location,
        status: status,
      );

      final success =
          await ReportService().updateReport(updatedReport, context);
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update report.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit report"),
        backgroundColor: const Color.fromARGB(255, 90, 1, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateReport,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(
                  labelText: "title",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => title = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter report name' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: details,
                decoration: InputDecoration(
                  labelText: "details",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => details = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter report type' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: location.toString(),
                decoration: InputDecoration(
                  labelText: "location",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                //keyboardType: TextInputType.number,
                onChanged: (value) => location = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter price' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: status,
                decoration: InputDecoration(
                  labelText: "status",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => status = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter unit' : null,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 4, 255),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: Text(
                    "Update Report",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
