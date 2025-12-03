import 'package:Capsule/models/report.dart';
import 'package:Capsule/screens/reports-screen/components/delete-report-dialog.dart';
import 'package:Capsule/screens/reports-screen/edit-report-screen/edit-report-screnn.dart';
import 'package:Capsule/screens/reports-screen/view-report-screen/view-report-screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportListItem extends StatelessWidget {
  final Report report;

  const ReportListItem(this.report, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ViewReportScreen(report)),
            );
          },
          leading: Image.asset('assets/icons/reports-screen.png'),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: report.status),
                    TextSpan(text: '   '),
                    TextSpan(
                      text: DateFormat.yMMMd('ar').format(report.dateTime),
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              Text(
                report.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          trailing: MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditReportScreen(report),
                    ),
                  );
                },
                leadingIcon: Icon(Icons.edit),
                child: Text('تعديل'),
              ),
              MenuItemButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteReportDialog(report),
                  );
                },
                leadingIcon: Icon(Icons.delete),
                child: Text('حذف'),
              ),
            ],
            builder: (_, controller, child) => IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ),
      ),
    );
  }
}
