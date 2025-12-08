import 'package:Capsule/models/illness.dart';
import 'package:Capsule/providers/illnesses-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:Capsule/screens/components/custom-drop-down-menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditIllnessScreen extends StatefulWidget {
  final Illness illness;
  const EditIllnessScreen(this.illness, {super.key});

  @override
  State<EditIllnessScreen> createState() => _EditIllnessScreenState();
}

class _EditIllnessScreenState extends State<EditIllnessScreen> {
  final _formKey = GlobalKey<FormState>();

  final _illnessNameController = TextEditingController();
  final _illnessDescriptionController = TextEditingController();
  final _illnessTypeController = TextEditingController();

  @override
  void initState() {
    _illnessNameController.text = widget.illness.name;
    _illnessDescriptionController.text = widget.illness.description;
    _illnessTypeController.text = widget.illness.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: Text('تعديل المرض')),
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
                      controller: _illnessNameController,
                      labelText: 'اسم المرض',
                      validator: (val) => val == null || val.isEmpty
                          ? 'الرجاء ادخال اسم المرض'
                          : null,
                    ),
                    SizedBox(height: 16),
                    CustomInput(
                      controller: _illnessDescriptionController,
                      labelText: 'الوصف',
                      maxLines: 5,
                    ),
                    SizedBox(height: 16),
                    CustomDropDownMenu<String>(
                      width: width,
                      controller: _illnessTypeController,
                      initialSelection: _illnessTypeController.text,
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
                              ).updateIllness(
                                Illness(
                                  id: widget.illness.id,
                                  name: _illnessNameController.text,
                                  description:
                                      _illnessDescriptionController.text,
                                  type: _illnessTypeController.text,
                                ),
                              );
                              Navigator.pop(context);
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
    );
  }
}
