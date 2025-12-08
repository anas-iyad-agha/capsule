import 'package:Capsule/models/test.dart';
import 'package:Capsule/providers/tests-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/tests-screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeleteTestDialog extends StatelessWidget {
  final Test test;
  const DeleteTestDialog(this.test, {super.key});

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
            Text(test.name, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              DateFormat.yMMMd('ar').format(test.date),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Colors.cyan,
                  onPressed: () {
                    Provider.of<TestsProvider>(
                      context,
                      listen: false,
                    ).deleteTest(test.id!);
                    Navigator.popUntil(
                      context,
                      (route) => route.settings.name == TestsScreen.route,
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
