import 'package:Capsule/models/report.dart';
import 'package:Capsule/providers/reports-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/add-report-screen/components/add_attachment_button.dart';
import 'package:Capsule/screens/clinical-file-screen/add-report-screen/components/attachments_list.dart';
import 'package:Capsule/screens/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditReportScreen extends StatefulWidget {
  final Report report;

  const EditReportScreen(this.report, {super.key});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController status = TextEditingController();

  final TextEditingController description = TextEditingController();

  @override
  void initState() {
    status.text = widget.report.status;
    description.text = widget.report.description;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل التقرير'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Center(
                  child: CustomInput(
                    labelText: 'الحالة',
                    controller: status,
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'الرجاء ادخال الحالة';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: CustomInput(
                    maxLines: 5,
                    border: OutlineInputBorder(),
                    controller: description,
                    labelText: 'الوصف',
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'الرجاء ادخال الوصف';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Expanded(child: AttachmentsList(showRemoveIcon: true)),
              Center(child: AddAttachmentButton()),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var provider = Provider.of<ReportsProvider>(
                            context,
                            listen: false,
                          );
                          await provider.editReport(
                            Report(
                              id: widget.report.id,
                              status: status.text,
                              description: description.text,
                              dateTime: widget.report.dateTime,
                            ),
                          );
                          await provider.fetchData();
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.cyan,
                      textColor: Colors.white,
                      child: Text('تأكيد'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
