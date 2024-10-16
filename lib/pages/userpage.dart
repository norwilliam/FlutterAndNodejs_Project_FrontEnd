import 'package:flutter/material.dart';
import 'package:flutter_lab1/controller/auth_service.dart';
import 'package:flutter_lab1/controller/report_service.dart';
import 'package:flutter_lab1/providers/user_providers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lab1/models/report_model.dart';
import 'package:flutter_lab1/pages/addpage.dart';

class UserWelcomePage extends StatefulWidget {
  const UserWelcomePage({super.key});

  @override
  _UserWelcomePage createState() => _UserWelcomePage();
}

class _UserWelcomePage extends State<UserWelcomePage> {
  late Future<List<ReportModel>>? futureReports;

  @override
  void initState() {
    super.initState();
    futureReports = ReportService().fetchReports(context);
  }

  void refreshReports() {
    setState(() {
      futureReports = ReportService().fetchReports(context);
    });
  }

  void _logout() async {
    try {
      await AuthService().logout(context);
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          "ระบบแจ้งซ่อม 📄",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 90, 1, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPage()),
                    );
                    if (result == true) {
                      refreshReports();
                    }
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'เพิ่มคำร้องแจ้งซ่อม',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold, // ทำให้ตัวหนา
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 90, 1, 255),
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'รายงานคำร้องแจ้งซ่อม',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15.0),
              FutureBuilder<List<ReportModel>>(
                future: futureReports,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No reports available.'));
                  }

                  final reports = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  'หัวข้อ: ${reports[index].title}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'รายละเอียด: ${reports[index].details}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'สถานที่: ${reports[index].location}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'สถานะ: ${reports[index].status}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("ลบคำร้องแจ้งซ่อม"),
                                              content: Text(
                                                  "การดำเนินการนี้ไม่สามารถย้อนกลับได้"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text("ยกเลิก"),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // ปิด dialog
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("ยืนยัน"),
                                                  onPressed: () async {
                                                    final isDeleted =
                                                        await ReportService()
                                                            .deleteReport(
                                                                context,
                                                                reports[index]
                                                                    .id);
                                                    if (isDeleted) {
                                                      refreshReports();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'ลบคำร้องแจ้งซ่อมสำเร็จ')),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'ลบคำร้องแจ้งซ่อมล้มเหลว')),
                                                      );
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
