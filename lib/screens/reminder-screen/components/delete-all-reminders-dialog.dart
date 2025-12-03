import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAllRemindersDialog extends StatelessWidget {
  const DeleteAllRemindersDialog({super.key});

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
              'هل انت متأكد من حذفك لجميع التنبيهات؟',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Colors.cyan,
                  onPressed: () async {
                    await Provider.of<MedicineReminderProvider>(
                      context,
                      listen: false,
                    ).removeAllReminders();
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
