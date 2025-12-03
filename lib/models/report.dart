import 'package:Capsule/models/attachment.dart';

class Report {
  final int? id;
  final String status;
  final String description;
  final DateTime dateTime;
  final List<Attachment> attachments;

  Report({
    this.id,
    required this.status,
    required this.description,
    required this.dateTime,
    this.attachments = const [],
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    id: json['id'],
    status: json['status'],
    description: json['description'],
    dateTime: DateTime.parse(json['date_time']),
    attachments: json['attachments'],
  );

  toJson() => {
    'id': id,
    'status': status,
    'description': description,
    'date_time': dateTime.toString(),
  };
}
