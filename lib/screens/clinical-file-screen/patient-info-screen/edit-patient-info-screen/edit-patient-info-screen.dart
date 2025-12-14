import 'package:capsule/models/patient-info.dart';
import 'package:capsule/providers/patien-info-probider.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:capsule/screens/components/curved-container.dart';
import 'package:capsule/screens/components/custom-drop-down-menu.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPatientInfoScreen extends StatefulWidget {
  final PatientInfo patientInfo;

  const EditPatientInfoScreen(this.patientInfo, {super.key});

  @override
  State<EditPatientInfoScreen> createState() => _EditPatientInfoScreenState();
}

class _EditPatientInfoScreenState extends State<EditPatientInfoScreen> {
  final fullNameController = TextEditingController();

  final jobController = TextEditingController();

  bool isMale = true;

  List<String> familyStatusOptions = ['أعزب', 'متزوج'];

  String familyStatus = '';

  List<String> bloodTypes = ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'];

  final weightController = TextEditingController();

  final heightController = TextEditingController();

  final bloodTypeController = TextEditingController();

  final allergiesController = TextEditingController();

  bool isSmoking = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fullNameController.text = widget.patientInfo.fullName;
    jobController.text = widget.patientInfo.job;
    isMale = widget.patientInfo.isMale;
    familyStatus = widget.patientInfo.familyStatus;
    bloodTypeController.text = widget.patientInfo.bloodType;
    weightController.text = widget.patientInfo.weight.toString();
    heightController.text = widget.patientInfo.height.toString();
    allergiesController.text = widget.patientInfo.allergies;
    isSmoking = widget.patientInfo.isSmoking;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: Text('تعديل معلومات المريض')),
      body: Column(
        children: [
          CurvedContainer(
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  CustomInput(
                    controller: fullNameController,
                    keyboardType: TextInputType.name,
                    validator: (val) =>
                        val!.isEmpty ? 'الرجاء ادخال الاسم' : null,
                    labelText: 'الاسم الثلاثي',
                  ),
                  const SizedBox(height: 32),

                  CustomInput(
                    controller: jobController,
                    keyboardType: TextInputType.name,
                    validator: (val) =>
                        val!.isEmpty ? 'الرجاء ادخال الاسم' : null,
                    labelText: 'الوظيفة',
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      CustomDropDownMenu<bool>(
                        width: (width / 2) - 56,
                        initialSelection: isMale,
                        label: 'الجنس',
                        onSelected: (val) {
                          if (val != null) {
                            setState(() {
                              isMale = val;
                            });
                          }
                        },
                        dropDownMenuEntries: [
                          DropdownMenuEntry(value: true, label: 'ذكر'),
                          DropdownMenuEntry(value: false, label: 'أنثى'),
                        ],
                      ),
                      SizedBox(width: 5),
                      CustomDropDownMenu<String>(
                        width: (width / 2) - 30,
                        initialSelection: familyStatus,
                        label: 'الحالة الاجتماعية',
                        onSelected: (val) {
                          if (val != null) {
                            setState(() {
                              familyStatus = val;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء اختيار الحالة الاجتماعية';
                          }
                          return null;
                        },
                        dropDownMenuEntries: [
                          for (var status in familyStatusOptions)
                            DropdownMenuEntry(value: status, label: status),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: CustomInput(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          suffixText: 'Kg',
                          labelText: 'الوزن',
                          validator: (val) => val == null || val.isEmpty
                              ? 'الرجاء ادخال الوزن'
                              : null,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomInput(
                          controller: heightController,
                          keyboardType: TextInputType.number,
                          suffixText: 'Cm',
                          labelText: 'الطول',
                          validator: (val) => val == null || val.isEmpty
                              ? 'الرجاء ادخال الطول'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownMenu(
                          // width: width / 2 - 4 - width / 20,
                          controller: bloodTypeController,
                          initialSelection: bloodTypeController.text,
                          label: 'فصيلة الدم',
                          dropDownMenuEntries: [
                            for (var bloodType in bloodTypes)
                              DropdownMenuEntry(
                                value: bloodType,
                                label: bloodType,
                              ),
                          ],
                          validator: (value) {
                            print(value.runtimeType);
                            if (value == null || value.isEmpty) {
                              return 'الرجاء اختيار فصيلة الدم';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text('مدخن'),
                          value: isSmoking,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                isSmoking = val;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  CustomInput(
                    controller: allergiesController,
                    labelText: 'الحساسيات',
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
                                Provider.of<PatientInfoProvider>(
                                  context,
                                  listen: false,
                                ).saveInfo(
                                  PatientInfo(
                                    fullName: fullNameController.text,
                                    job: jobController.text,
                                    isMale: isMale,
                                    familyStatus: familyStatus,
                                    weight: double.parse(weightController.text),
                                    height: double.parse(heightController.text),
                                    bloodType: bloodTypeController.text,
                                    allergies: allergiesController.text,
                                    isSmoking: isSmoking,
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
                                    'حفظ التغييرات',
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
        ],
      ),
    );
  }
}
