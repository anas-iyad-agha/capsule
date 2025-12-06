import 'package:Capsule/models/illness.dart';
import 'package:Capsule/providers/illnesses-provider.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:Capsule/screens/components/custom-drop-down-menu.dart';
import 'package:Capsule/screens/medicine/add-medicine-screen/components/custom_input.dart';
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
      body: CurvedContainer(
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                          onPressed: () async {
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
          ),
        ),
      ),
    );
  }
}
