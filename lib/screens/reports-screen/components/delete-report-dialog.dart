import 'package:Capsule/models/report.dart';
import 'package:Capsule/providers/reports-provider.dart';
import 'package:Capsule/screens/reports-screen/reportsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteReportDialog extends StatelessWidget {
  final Report report;
  const DeleteReportDialog(this.report, {super.key});

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
              'هل انت متأكد من حذفك لهذا التقرير؟',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
            Text(report.status, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              report.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Colors.cyan,
                  onPressed: () async {
                    await Provider.of<ReportsProvider>(
                      context,
                      listen: false,
                    ).removeReport(report.id!);
                    Navigator.popUntil(
                      context,
                      (route) => route.settings.name == ReportsScreen.route,
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
