import 'dart:io';

import 'package:Capsule/models/test.dart';
import 'package:Capsule/providers/tests-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/components/add-attachment-button.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/components/file-card.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTestScreen extends StatefulWidget {
  static const route = '/clinical-file/tests/add';
  const AddTestScreen({super.key});

  @override
  State<AddTestScreen> createState() => _AddTestScreenState();
}

class _AddTestScreenState extends State<AddTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? dateTime;
  File? file;

  _selectTime() async {
    dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3000)),
    );

    setState(() {});
  }

  _selectFile() async {
    var response = await FilePicker.platform.pickFiles();
    if (response != null && response.files.first.path != null) {
      file = File(response.files.first.path!);
      setState(() {});
    }
  }

  _removeFile() {
    file = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اضافة تحليل')),
      body: CurvedContainer(
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInput(
                controller: _nameController,
                labelText: 'اسم',
                validator: (val) =>
                    val == null || val.isEmpty ? 'الرجاء ملئ الاسم' : null,
              ),
              SizedBox(height: 32),
              GestureDetector(
                onTap: _selectTime,
                child: TextFormField(
                  enabled: false,
                  validator: (_) {
                    if (dateTime == null) {
                      return 'الرجاء اختيار التاريخ';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: dateTime == null
                        ? 'تاريخ'
                        : DateFormat.yMMMd('ar').format(dateTime!),
                    labelStyle: const TextStyle(color: Colors.black54),
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              file == null
                  ? AddAttachmentButton(_selectFile)
                  : FileCard(file!, onDeleteCallback: _removeFile),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var provider = Provider.of<TestsProvider>(
                          context,
                          listen: false,
                        );
                        provider.addTest(
                          Test(
                            name: _nameController.text,
                            date: dateTime!,
                            attachment: file?.path,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.cyan,
                    textColor: Colors.white,
                    child: Text('إضافة'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll(
                        BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
