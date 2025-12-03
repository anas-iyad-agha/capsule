import 'package:Capsule/models/medicine.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:flutter/material.dart';
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

  final _currentSupplyController = TextEditingController();

  final _doseController = TextEditingController();

  final _strengthController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.medicine.name;
    _descriptionController.text = widget.medicine.description;
    _currentSupplyController.text = widget.medicine.currentSupply.toString();
    _doseController.text = widget.medicine.dose.toString();
    _strengthController.text = widget.medicine.strength.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الدواء'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
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
              CustomInput(
                labelText: 'الكمية الحالية',
                suffixText: 'حبة',
                controller: _currentSupplyController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value).runtimeType != double) {
                    return 'الرجاء ادخال الكمية الحالية';
                  }
                  return null;
                },
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
                          if (double.tryParse(value).runtimeType != double) {
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
                        var provider = Provider.of<MedicineReminderProvider>(
                          context,
                          listen: false,
                        );
                        await provider
                            .updateMedicine(
                              Medicine(
                                id: widget.medicine.id,
                                name: _nameController.text,
                                description: _descriptionController.text,
                                currentSupply: double.parse(
                                  _currentSupplyController.text,
                                ),
                                dose: double.parse(_doseController.text),
                                strength: double.parse(
                                  _strengthController.text,
                                ),
                              ),
                            )
                            .then((_) async => await provider.fetchData());
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.teal,
                    textColor: Colors.white,
                    child: Text('تأكيد'),
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
