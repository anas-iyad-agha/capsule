import 'package:Capsule/models/patient-info.dart';
import 'package:Capsule/providers/patien-info-probider.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:Capsule/screens/components/custom-drop-down-menu.dart';
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
      body: CurvedContainer(
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomInput(
                controller: fullNameController,
                keyboardType: TextInputType.name,
                validator: (val) => val!.isEmpty ? 'الرجاء ادخال الاسم' : null,
                labelText: 'الاسم الثلاثي',
              ),
              CustomInput(
                controller: jobController,
                keyboardType: TextInputType.name,
                validator: (val) => val!.isEmpty ? 'الرجاء ادخال الاسم' : null,
                labelText: 'الوظيفة',
              ),
              Row(
                children: [
                  CustomDropDownMenu<bool>(
                    width: width / 2 - 12,
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
                  SizedBox(width: 8),
                  CustomDropDownMenu<String>(
                    width: width / 2 - 12,
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
              Row(
                children: [
                  CustomDropDownMenu(
                    width: width / 2 - 12,
                    controller: bloodTypeController,
                    initialSelection: bloodTypeController.text,
                    label: 'فصيلة الدم',
                    dropDownMenuEntries: [
                      for (var bloodType in bloodTypes)
                        DropdownMenuEntry(value: bloodType, label: bloodType),
                    ],
                    validator: (value) {
                      print(value.runtimeType);
                      if (value == null || value.isEmpty) {
                        return 'الرجاء اختيار فصيلة الدم';
                      }
                      return null;
                    },
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: width / 2 - 12,
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
              CustomInput(
                controller: allergiesController,
                labelText: 'الحساسيات',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    color: Colors.cyan,
                    onPressed: () {
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
                    child: Text('تعديل', style: TextStyle(color: Colors.white)),
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
            ],
          ),
        ),
      ),
    );
  }
}
