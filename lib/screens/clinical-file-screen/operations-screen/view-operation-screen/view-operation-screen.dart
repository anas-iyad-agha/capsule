import 'package:Capsule/models/operation.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/components/delete-operation-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/edit-operation-screen/edit-operation-screen.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';

class ViewOperationScreen extends StatelessWidget {
  final Operation operation;
  const ViewOperationScreen(this.operation, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: Text('معلومات العملية')),
      body: CurvedContainer(
        SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                operation.name,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 32),
              Text(
                operation.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditOperationScreen(operation),
                    ),
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
                    builder: (_) => DeleteOperationDialog(operation),
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
    );
  }
}
