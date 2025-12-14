import 'package:capsule/models/illness.dart';
import 'package:capsule/providers/illnesses-provider.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:capsule/screens/components/curved-container.dart';
import 'package:capsule/screens/components/custom-drop-down-menu.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddIllnessScreen extends StatefulWidget {
  static const route = '/clinical-file/illnesses/add';

  const AddIllnessScreen({super.key});

  @override
  State<AddIllnessScreen> createState() => _AddIllnessScreenState();
}

class _AddIllnessScreenState extends State<AddIllnessScreen> {
  final _formKey = GlobalKey<FormState>();

  final illnessNameController = TextEditingController();
  final illnessDescriptionController = TextEditingController();
  final illnessTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('تسجل مرض')),
      backgroundColor: Colors.cyan,
      body: Column(
        children: [
          CurvedContainer(
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomInput(
                        controller: illnessNameController,
                        labelText: 'اسم المرض',
                        validator: (val) => val == null || val.isEmpty
                            ? 'الرجاء ادخال اسم المرض'
                            : null,
                      ),
                      SizedBox(height: 16),
                      CustomInput(
                        controller: illnessDescriptionController,
                        labelText: 'الوصف',
                        maxLines: 5,
                      ),
                      SizedBox(height: 16),
                      CustomDropDownMenu<String>(
                        width: width,
                        controller: illnessTypeController,
                        label: 'نوع المرض',
                        dropDownMenuEntries: [
                          for (String illnessType in Illness.illnessTypes)
                            DropdownMenuEntry(
                              value: illnessType,
                              label: illnessType,
                            ),
                        ],
                        validator: (val) => val == null || val.isEmpty
                            ? 'الرجاء ادخال اسم المرض'
                            : null,
                      ),
                      SizedBox(height: 32),
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
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Provider.of<IllnessesProvider>(
                                      context,
                                      listen: false,
                                    ).addIllness(
                                      Illness(
                                        name: illnessNameController.text,
                                        description:
                                            illnessDescriptionController.text,
                                        type: illnessTypeController.text,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
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
                    ],
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
