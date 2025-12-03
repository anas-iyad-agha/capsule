import 'package:Capsule/models/medicine.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/medicine/medicine-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteMedicineDialog extends StatelessWidget {
  final Medicine medicine;
  const DeleteMedicineDialog(this.medicine, {super.key});

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
              'هل انت متأكد من حذفك لهذا الدواء؟',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
            Text(medicine.name, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              medicine.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Colors.teal,
                  onPressed: () async {
                    await Provider.of<MedicineReminderProvider>(
                      context,
                      listen: false,
                    ).deleteMedicine(medicine.id!);
                    Navigator.popUntil(
                      context,
                      (route) => route.settings.name == MedicineScreen.route,
                    );
                  },
                  child: Text('نعم', style: TextStyle(color: Colors.white)),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  child: Text('لا', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
