import 'dart:io';

import 'package:capsule/models/test.dart';
import 'package:capsule/providers/tests-provider.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/components/add-attachment-button.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/components/file-card.dart';
import 'package:capsule/theme.dart';
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
  DateTime? selectedDate;
  File? selectedFile;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 3000)),
      lastDate: DateTime.now().add(const Duration(days: 3000)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColors.primaryBlue,
              onPrimary: MyColors.white,
              surface: MyColors.white,
              onSurface: MyColors.darkNavyBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectFile() async {
    try {
      var response = await FilePicker.platform.pickFiles();
      if (response != null && response.files.first.path != null) {
        setState(() {
          selectedFile = File(response.files.first.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('حدث خطأ عند تحميل الملف'),
          backgroundColor: MyColors.lightRed,
        ),
      );
    }
  }

  void _removeFile() {
    setState(() {
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة تحليل'), elevation: 0),
      backgroundColor: MyColors.veryLightGray,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // اسم التحليل
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: MyColors.warmPeach.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.science_rounded,
                              color: MyColors.warmPeach,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'معلومات التحليل',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: MyColors.darkNavyBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomInput(
                        controller: _nameController,
                        labelText: 'اسم التحليل',
                        hintText: 'مثال: تحليل الدم',
                        prefixIcon: Icon(Icons.label_rounded),
                        validator: (val) => val == null || val.isEmpty
                            ? 'الرجاء إدخال اسم التحليل'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // التاريخ
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: MyColors.primaryBlue.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.calendar_today_rounded,
                              color: MyColors.primaryBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'تاريخ التحليل',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: MyColors.darkNavyBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _selectDate,
                        child: TextFormField(
                          enabled: false,
                          validator: (_) {
                            if (selectedDate == null) {
                              return 'الرجاء اختيار التاريخ';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: selectedDate == null
                                ? 'تاريخ'
                                : DateFormat.yMMMd('ar').format(selectedDate!),
                            labelStyle: const TextStyle(color: Colors.black54),
                            prefixIcon: const Icon(Icons.date_range_rounded),

                            disabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // الملف المرفق
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: MyColors.accentTeal.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.attach_file_rounded,
                              color: MyColors.accentTeal,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'الملف المرفق',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: MyColors.darkNavyBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (selectedFile == null)
                        ElevatedButton.icon(
                          onPressed: _selectFile,
                          icon: const Icon(Icons.cloud_upload_rounded),
                          label: const Text('اختر ملف'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.accentTeal.withOpacity(
                              0.1,
                            ),
                            foregroundColor: MyColors.accentTeal,
                            elevation: 0,
                          ),
                        )
                      else
                        Column(
                          children: [
                            FileCard(
                              selectedFile!,
                              onDeleteCallback: _removeFile,
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: _selectFile,
                              icon: const Icon(Icons.edit_rounded),
                              label: const Text('استبدال الملف'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // زر الحفظ
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MyColors.primaryBlue,
                          MyColors.primaryBlue.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.primaryBlue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            var provider = Provider.of<TestsProvider>(
                              context,
                              listen: false,
                            );
                            provider.addTest(
                              Test(
                                name: _nameController.text,
                                date: selectedDate!,
                                attachment: selectedFile?.path,
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Text('تم إضافة التحليل بنجاح'),
                                  ],
                                ),
                                backgroundColor: MyColors.accentTeal,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );

                            Navigator.pop(context);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.save_rounded,
                                color: MyColors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'إضافة',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: MyColors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // زر الإلغاء
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.lightRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: MyColors.lightRed.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.cancel_rounded,
                                color: MyColors.lightRed,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'إلغاء',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: MyColors.lightRed,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // الأزرار
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
