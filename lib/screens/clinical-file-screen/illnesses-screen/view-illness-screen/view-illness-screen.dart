import 'package:Capsule/models/illness.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/components/delete-illness-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/edit-illness-screen/edit-illness-screen.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';

class ViewIllnessScreen extends StatelessWidget {
  final Illness illness;
  const ViewIllnessScreen(this.illness, {super.key});

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
                illness.name,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 32),
              Text(illness.type, style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 32),
              Text(
                illness.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditIllnessScreen(illness),
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
                    builder: (_) => DeleteIllnessDialog(illness),
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
