import 'dart:io';

import 'package:Capsule/models/test.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/components/delete-test-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/components/file-card.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/edit-test-screen/edit-test-screen.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewTestScreen extends StatelessWidget {
  final Test test;
  const ViewTestScreen(this.test, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: Text('معلومات العملية')),
      body: Column(
        children: [
          CurvedContainer(
            SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    test.name,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 32),
                  Text(
                    DateFormat.yMMMd('ar').format(test.date),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 32),
                  test.attachment != null
                      ? FileCard(File(test.attachment!), isDeletable: false)
                      : SizedBox(),
                  SizedBox(height: 32),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditTestScreen(test)),
                      );
                    },
                    child: Container(
                      width: width,
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'تعديل',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => DeleteTestDialog(test),
                      );
                    },
                    child: Container(
                      width: width,
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan.withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'حذف',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(color: Colors.cyan),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
