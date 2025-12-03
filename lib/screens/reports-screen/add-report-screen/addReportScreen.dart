import 'package:Capsule/models/report.dart';
import 'package:Capsule/providers/reports-provider.dart';
import 'package:Capsule/screens/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:Capsule/screens/reports-screen/add-report-screen/components/add_attachment_button.dart';
import 'package:Capsule/screens/reports-screen/add-report-screen/components/attachments_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddReportScreen extends StatelessWidget {
  static const route = '/reports/add';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController status = TextEditingController();
  final TextEditingController description = TextEditingController();

  AddReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة تقرير'),
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
              CustomInput(
                labelText: 'الحالة',
                controller: status,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'الرجاء ادخال الحالة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              CustomInput(
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
              SizedBox(height: 12),
              Expanded(flex: 3, child: AttachmentsList(showRemoveIcon: true)),
              Center(child: AddAttachmentButton()),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      color: Colors.cyan,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var provider = Provider.of<ReportsProvider>(
                            context,
                            listen: false,
                          );
                          await provider.insertReport(
                            Report(
                              status: status.text,
                              description: description.text,
                              dateTime: DateTime.now(),
                            ),
                          );
                          await provider.fetchData();
                          provider.selectedAttachments.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'تأكيد',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Provider.of<ReportsProvider>(
                          context,
                          listen: false,
                        ).selectedAttachments.clear();
                        Navigator.pop(context);
                      },
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
