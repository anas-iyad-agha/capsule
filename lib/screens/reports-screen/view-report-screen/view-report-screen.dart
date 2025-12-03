import 'package:Capsule/models/report.dart';
import 'package:Capsule/providers/reports-provider.dart';
import 'package:Capsule/screens/reports-screen/add-report-screen/components/attachments_list.dart';
import 'package:Capsule/screens/reports-screen/components/delete-report-dialog.dart';
import 'package:Capsule/screens/reports-screen/edit-report-screen/edit-report-screnn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewReportScreen extends StatefulWidget {
  final Report report;
  const ViewReportScreen(this.report, {super.key});

  @override
  State<ViewReportScreen> createState() => _ViewReportScreenState();
}

class _ViewReportScreenState extends State<ViewReportScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportsProvider>(
        context,
        listen: false,
      ).initSelectedAttachments(
        widget.report.attachments.map((e) => e.file).toList(),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('التقرير: #${widget.report.id}'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        actions: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditReportScreen(widget.report),
                    ),
                  );
                },
                leadingIcon: Icon(Icons.edit),
                child: Text('تعديل'),
              ),
              MenuItemButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => DeleteReportDialog(widget.report),
                  );
                },
                leadingIcon: Icon(Icons.delete),
                child: Text('حذف'),
              ),
            ],
            builder: (_, controller, _) => IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/icons/reports-screen.png',
                width: width / 2,
              ),
            ),
            SizedBox(height: 24),
            Text('الحالة : ${widget.report.status}'),
            SizedBox(height: 8),
            Text('الوصف : ${widget.report.description}', softWrap: true),
            SizedBox(height: 8),
            Text(
              'الوقت : ${DateFormat.yMMMd('ar').format(widget.report.dateTime)}  ${DateFormat.jm('ar').format(widget.report.dateTime)}',
            ),

            SizedBox(height: 24),
            AttachmentsList(),
          ],
        ),
      ),
    );
  }
}
