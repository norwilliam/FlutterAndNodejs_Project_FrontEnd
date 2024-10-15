import 'package:flutter/material.dart';
import 'package:flutter_lab1/providers/user_providers.dart';
import 'package:flutter_lab1/variables.dart';
import 'package:flutter_lab1/models/report_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class ReportService {
  Future<List<ReportModel>> fetchReports(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('$apiURL/api/reports'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          return jsonResponse
              .map<ReportModel>((report) => ReportModel.fromJson(report))
              .toList();
        } else {
          throw Exception('No data available');
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error: $e');
      throw Exception('Failed to load reports: $e');
    }
  }

  Future<bool> addReport(BuildContext context, ReportModel report) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.post(
        Uri.parse('$apiURL/api/report'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
        body: jsonEncode(report.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to add report: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding report: $e');
      return false;
    }
  }

  Future<bool> deleteReport(BuildContext context, String reportId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.delete(
        Uri.parse('$apiURL/api/report/$reportId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete report: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting report: $e');
      return false;
    }
  }

  Future<bool> updateReport(ReportModel report, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.put(
        Uri.parse('$apiURL/api/report/${report.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
        body: jsonEncode(report.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update report: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating report: $e');
      return false;
    }
  }
}
