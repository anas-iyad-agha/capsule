import 'package:Capsule/models/illness.dart';
import 'package:Capsule/providers/illnesses-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/illnesses-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/view-all-info-screen/view-all-info-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteIllnessDialog extends StatelessWidget {
  final Illness illness;
  const DeleteIllnessDialog(this.illness, {super.key});

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
            Text(illness.name, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              illness.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Colors.cyan,
                  onPressed: () {
                    Provider.of<IllnessesProvider>(
                      context,
                      listen: false,
                    ).deleteIllness(illness.id!);
                    Navigator.popUntil(
                      context,
                      (route) =>
                          route.settings.name == IllnessesScreen.route ||
                          route.settings.name == ViewAllInfoScreen.route,
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
