import 'dart:convert';

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  String id;
  String title;
  String details;
  String location;
  String status;

  ReportModel(
      {required this.id,
      required this.title,
      required this.details,
      required this.location,
      required this.status});

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json["_id"] ?? '', // ตั้งค่าเป็นค่าว่างหากเป็น null
        title: json["title"] ?? '',
        details: json["details"] ?? '',
        location: json["location"] ?? '',
        status: json["status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "details": details,
        "location": location,
        "status": status
      };
}
