import 'dart:io';

class Attachment {
  final int? id;
  final int reportId;
  final File file;

  Attachment({this.id, required this.reportId, required this.file});

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json['id'],
    reportId: json['report_id'],
    file: File(json['file_path']),
  );

  toJson() => {'id': id, 'report_id': reportId, 'file_path': file};
}
