import 'dart:io';

import 'package:capsule/local-db/localDB.dart';
import 'package:capsule/models/test.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TestsProvider with ChangeNotifier {
  List<Test> tests = [];

  Future getTests() async {
    tests.clear();
    var response = await Localdb.db!.query('tests');

    response.forEach((test) => tests.add(Test.fromJson(test)));

    notifyListeners();
  }

  Future addTest(Test test) async {
    File? newFile;
    if (test.attachment != null) {
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();

      final String attachmentsDirPath = p.join(
        appDocumentsDir.path,
        'attachments',
      );
      final Directory attachmentsDir = Directory(attachmentsDirPath);

      if (!await attachmentsDir.exists()) {
        await attachmentsDir.create(recursive: true);
      }

      final String fileName = p.basename(test.attachment!);

      // 5. Define the new file path
      final String newFilePath = p.join(attachmentsDirPath, fileName);

      newFile = await File(test.attachment!).copy(newFilePath);
    }

    int id = await Localdb.db!.insert('tests', {
      'name': test.name,
      'date': test.date.toString(),
      'attachment': newFile?.path,
    });

    if (id < 1) {
      throw Exception('id is less than 1');
    }
    await getTests();
    notifyListeners();
  }

  Future deleteTest(int id) async {
    int effectedRows = await Localdb.db!.delete('tests', where: 'id = $id');

    if (effectedRows != 1) {
      throw Exception('effected rows are not 1');
    }
    await getTests();

    notifyListeners();
  }

  Future updateTest(Test test) async {
    File? newFile;
    if (test.attachment != null) {
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();

      final String attachmentsDirPath = p.join(
        appDocumentsDir.path,
        'attachments',
      );
      final Directory attachmentsDir = Directory(attachmentsDirPath);

      if (!await attachmentsDir.exists()) {
        await attachmentsDir.create(recursive: true);
      }

      final String fileName = p.basename(test.attachment!);

      // 5. Define the new file path
      final String newFilePath = p.join(attachmentsDirPath, fileName);

      newFile = await File(test.attachment!).copy(newFilePath);
    }

    int effectedRows = await Localdb.db!.update('tests', {
      'name': test.name,
      'date': test.date.toString(),
      'attachment': newFile?.path,
    }, where: 'id = ${test.id}');

    if (effectedRows != 1) {
      throw Exception('effected rows are not 1');
    }

    await getTests();
    notifyListeners();
  }
}
