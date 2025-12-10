import 'package:Capsule/models/medicine.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/medicine-screen.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditMedicineScreen extends StatefulWidget {
  final Medicine medicine;

  const EditMedicineScreen(this.medicine, {super.key});

  @override
  State<EditMedicineScreen> createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _doseController = TextEditingController();

  final _strengthController = TextEditingController();

  DateTime? _startDate;

  DateTime? _endDate;

  @override
  void initState() {
    _nameController.text = widget.medicine.name;
    _descriptionController.text = widget.medicine.description;
    _doseController.text = widget.medicine.dose.toString();
    _strengthController.text = widget.medicine.strength.toString();
    _startDate = widget.medicine.startDate;
    _endDate = widget.medicine.endDate;
    super.initState();
  }

  _selectStartDate() async {
    _startDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 3000)),
      lastDate: DateTime.now().add(Duration(days: 3000)),
    );

    setState(() {});
  }

  _selectEndDate() async {
    _endDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 3000)),
      lastDate: DateTime.now().add(Duration(days: 3000)),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الدواء'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          CurvedContainer(
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomInput(
                    labelText: 'اسم الدواء',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء ادخال اسم الدواء';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  CustomInput(
                    keyboardType: TextInputType.multiline,
                    controller: _descriptionController,
                    maxLines: null,
                    labelText: 'الوصف',
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: _selectStartDate,
                    child: TextFormField(
                      enabled: false,
                      validator: (_) {
                        if (_startDate == null) {
                          return 'الرجاء اختيار تاريخ البدء';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: _startDate == null
                            ? 'تاريخ البدء'
                            : DateFormat.yMMMd('ar').format(_startDate!),
                        labelStyle: const TextStyle(color: Colors.black54),
                        disabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: _selectEndDate,
                    child: TextFormField(
                      enabled: false,
                      validator: (_) {
                        if (_endDate == null) {
                          return 'الرجاء اختيار تاريخ الانتهاء';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: _endDate == null
                            ? 'تاريخ الانتهاء'
                            : DateFormat.yMMMd('ar').format(_endDate!),
                        labelStyle: const TextStyle(color: Colors.black54),
                        disabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Flexible(
                        child: CustomInput(
                          labelText: 'الجرعة',
                          suffixText: 'حبة',
                          controller: _doseController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                double.tryParse(value).runtimeType != double) {
                              return 'الرجاء ادخال الجرعة';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 24),
                      Flexible(
                        child: CustomInput(
                          labelText: 'العيار',
                          suffixText: 'ميلي غرام',
                          controller: _strengthController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (!(value == null || value.isEmpty)) {
                              if (double.tryParse(value).runtimeType !=
                                  double) {
                                return 'الرجاء ادخال العيار';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var provider =
                                Provider.of<MedicineReminderProvider>(
                                  context,
                                  listen: false,
                                );
                            await provider
                                .updateMedicine(
                                  Medicine(
                                    id: widget.medicine.id,
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    dose: double.parse(_doseController.text),
                                    strength: double.parse(
                                      _strengthController.text,
                                    ),
                                    startDate: _startDate!,
                                    endDate: _endDate!,
                                  ),
                                )
                                .then((_) async => await provider.fetchData());
                            Navigator.pop(context);
                          }
                        },
                        color: Colors.cyan,
                        textColor: Colors.white,
                        child: Text('تأكيد'),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name == MedicineScreen.route,
                        ),
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
        ],
      ),
    );
  }
}
