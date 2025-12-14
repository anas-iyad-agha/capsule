import 'dart:io';

import 'package:capsule/models/test.dart';
import 'package:capsule/providers/tests-provider.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/components/add-attachment-button.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/components/file-card.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/tests-screen.dart';
import 'package:capsule/screens/clinical-file-screen/view-all-info-screen/view-all-info-screen.dart';
import 'package:capsule/screens/components/curved-container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTestScreen extends StatefulWidget {
  final Test test;
  const EditTestScreen(this.test, {super.key});

  @override
  State<EditTestScreen> createState() => _EditTestScreenState();
}

class _EditTestScreenState extends State<EditTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? dateTime;
  File? file;

  @override
  void initState() {
    _nameController.text = widget.test.name;
    dateTime = widget.test.date;
    if (widget.test.attachment != null) {
      file = File(widget.test.attachment!);
    }
    super.initState();
  }

  _selectTime() async {
    dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 3000)),
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
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: Text('تعديل المرض')),
      backgroundColor: Colors.cyan,
      body: Column(
        children: [
          CurvedContainer(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomInput(
                          controller: _nameController,
                          labelText: 'اسم المرض',
                          validator: (val) => val == null || val.isEmpty
                              ? 'الرجاء ادخال اسم المرض'
                              : null,
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
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                              ),
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Provider.of<TestsProvider>(
                                    context,
                                    listen: false,
                                  ).updateTest(
                                    Test(
                                      id: widget.test.id,
                                      name: _nameController.text,
                                      date: dateTime!,
                                      attachment: file?.path,
                                    ),
                                  );
                                  Navigator.popUntil(
                                    context,
                                    (route) =>
                                        route.settings.name ==
                                            TestsScreen.route ||
                                        route.settings.name ==
                                            ViewAllInfoScreen.route,
                                  );
                                }
                              },
                              color: Colors.cyan,
                              textColor: Colors.white,
                              child: Text('تعديل'),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
