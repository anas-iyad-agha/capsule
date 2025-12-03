import 'package:flutter/material.dart';

class NoMedicineDialog extends StatelessWidget {
  const NoMedicineDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'لا يوجد اي ادوية لاضافة تنبيه لها',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
            MaterialButton(
              color: Colors.greenAccent,
              onPressed: () => Navigator.pop(context),
              child: Text('حسنا'),
            ),
          ],
        ),
      ),
    );
  }
}
