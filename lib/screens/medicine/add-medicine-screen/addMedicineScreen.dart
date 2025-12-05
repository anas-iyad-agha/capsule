import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMedicineScreen extends StatelessWidget {
  static final route = '/medicine/add';
  AddMedicineScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _currentSupplyController = TextEditingController(
    text: '1',
  );
  final TextEditingController _doseController = TextEditingController(
    text: '1',
  );
  final TextEditingController _strengthController = TextEditingController(
    text: '1',
  );

  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.sizeOf(context).width / 20;
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة دواء'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(padding),
        alignment: Alignment.center,
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
                    return 'الرجاء ادخل الكمية الحالية';
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
                      suffixText: 'ميلي جرام',
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
                            .insertMedicine(
                              _nameController.text,
                              _descriptionController.text,
                              double.parse(_currentSupplyController.text),
                              double.parse(_doseController.text),
                              double.parse(_strengthController.text),
                            )
                            .then((_) async => await provider.fetchData());
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
