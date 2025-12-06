import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/add-patient-info-screen/add-patient-info-screen.dart';
import 'package:flutter/material.dart';

class AddPatientInfoDialog extends StatelessWidget {
  const AddPatientInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'يحب ادخال معلومات المريض اولا',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Colors.cyan,
                  onPressed: () => Navigator.popAndPushNamed(
                    context,
                    AddPatientInfoScreen.route,
                  ),
                  child: Text('ادخال', style: TextStyle(color: Colors.white)),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  child: Text(
                    'الغاء',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
