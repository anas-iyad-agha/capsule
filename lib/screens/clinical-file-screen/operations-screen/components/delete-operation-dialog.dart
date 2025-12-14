import 'package:capsule/models/operation.dart';
import 'package:capsule/providers/operations-provider.dart';
import 'package:capsule/screens/clinical-file-screen/operations-screen/operations-screen.dart';
import 'package:capsule/screens/clinical-file-screen/view-all-info-screen/view-all-info-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteOperationDialog extends StatelessWidget {
  final Operation operation;
  const DeleteOperationDialog(this.operation, {super.key});

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
            Text(operation.name, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              operation.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Colors.cyan,
                  onPressed: () {
                    Provider.of<OperationsProvider>(
                      context,
                      listen: false,
                    ).deleteOperation(operation.id!);
                    Navigator.popUntil(
                      context,
                      (route) =>
                          route.settings.name == OperationsScreen.route ||
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
