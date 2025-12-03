import 'dart:io';

import 'package:Capsule/local-db/localDB.dart';
import 'package:Capsule/models/attachment.dart';
import 'package:Capsule/models/report.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

enum ReportsProviderState { initial, loading, loaded, error }

class ReportsProvider with ChangeNotifier {
  List<Report> reports = [];

  List<File> selectedAttachments = [];
  ReportsProviderState state = ReportsProviderState.initial;

  Future<void> fetchData({String status = ''}) async {
    state = ReportsProviderState.loading;
    notifyListeners();
    try {
      var reportsData = await Localdb.db!.query(
        'reports',
        where: 'status LIKE "%$status%"',
      );
      var attachmentData = await Localdb.db!.query('attachments');
      reports = reportsData.map((report) {
        List<Attachment> attachments = attachmentData
            .where((attachment) => attachment['report_id'] == report['id'])
            .map((attachment) => Attachment.fromJson(attachment))
            .toList();

        return Report.fromJson({
          'id': report['id'],
          'status': report['status'],
          'description': report['description'],
          'date_time': report['date_time'],
          'attachments': attachments,
        });
      }).toList();

      state = ReportsProviderState.loaded;
    } catch (e) {
      print(e.toString());
      state = ReportsProviderState.error;
    }
    notifyListeners();
  }

  Future selectAttachments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      selectedAttachments.addAll(result.paths.map((path) => File(path!)));
      notifyListeners();
    }
  }

  initSelectedAttachments(List<File> attachments) {
    selectedAttachments = attachments;
    notifyListeners();
  }

  removeSelectedAttachment(File attachment) {
    selectedAttachments.remove(attachment);
    notifyListeners();
  }

  Future editReport(Report report) async {
    await Localdb.db!.transaction((txn) async {
      print(report.id);
      int effectedRows = await txn.update('reports', {
        'status': report.status,
        'description': report.description,
        'date_time': report.dateTime.toString(),
      }, where: 'id = ${report.id}');

      if (effectedRows != 1) {
        throw Exception(
          'error effected rows when updating reports table are : $effectedRows',
        );
      }

      txn.delete('attachments', where: 'report_id = ${report.id}');

      Batch batch = txn.batch();
      final directory = await getApplicationDocumentsDirectory();
      for (File file in selectedAttachments) {
        final String path =
            '${directory.path}/attachments/${p.basenameWithoutExtension(file.path)}-${DateTime.now().millisecondsSinceEpoch}-${p.extension(file.path)}';

        File savedFile = File(path);
        final parentDir = savedFile.parent;
        if (!await parentDir.exists()) {
          await parentDir.create(recursive: true);
        }
        savedFile.writeAsBytes(await file.readAsBytes());

        final attachment = {'report_id': report.id, 'file_path': path};

        batch.insert('attachments', attachment);
      }

      await batch.commit();
    });
  }

  Future removeReport(int reportId) async {
    int rowsCount = await Localdb.db!.delete(
      'reports',
      where: 'id = ${reportId}',
    );
    if (rowsCount != 1) {
      throw Exception(
        'Failed to delete report and the effected rows are :: $rowsCount',
      );
    }
    reports.removeWhere((report) => report.id == reportId);
    notifyListeners();
  }

  Future<void> insertReport(Report report) async {
    state = ReportsProviderState.loading;
    notifyListeners();

    try {
      await Localdb.db!.transaction((txn) async {
        int reportId = await txn.insert('reports', report.toJson());
        if (reportId == -1) throw Exception('Failed to insert report');

        Batch batch = txn.batch();
        final directory = await getApplicationDocumentsDirectory();
        for (File file in selectedAttachments) {
          final String path =
              '${directory.path}/attachments/${p.basenameWithoutExtension(file.path)}-${DateTime.now().millisecondsSinceEpoch}-${p.extension(file.path)}';

          File savedFile = File(path);
          final parentDir = savedFile.parent;
          if (!await parentDir.exists()) {
            await parentDir.create(recursive: true);
          }
          savedFile.writeAsBytes(await file.readAsBytes());

          final attachment = {'report_id': reportId, 'file_path': path};

          batch.insert('attachments', attachment);
        }

        await batch.commit();
      });

      state = ReportsProviderState.loaded;
    } catch (e) {
      print(e.toString());
      state = ReportsProviderState.error;
    }
    notifyListeners();
  }
}
