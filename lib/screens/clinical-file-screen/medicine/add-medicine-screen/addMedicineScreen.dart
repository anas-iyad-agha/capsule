import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:capsule/screens/components/curved-container.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddMedicineScreen extends StatefulWidget {
  static final route = '/clinical-file/medicine/add';
  AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _doseController = TextEditingController(
    text: '1',
  );

  final TextEditingController _strengthController = TextEditingController(
    text: '1',
  );

  DateTime? _startDate;

  DateTime? _endDate;

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
        title: Text('إضافة دواء'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          CurvedContainer(
            Center(
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
                                  double.tryParse(value).runtimeType !=
                                      double) {
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
                                  var provider =
                                      Provider.of<MedicineReminderProvider>(
                                        context,
                                        listen: false,
                                      );
                                  await provider
                                      .insertMedicine(
                                        _nameController.text,
                                        _descriptionController.text,
                                        double.parse(_doseController.text),
                                        double.parse(_strengthController.text),
                                        _startDate!,
                                        _endDate!,
                                      )
                                      .then(
                                        (_) async => await provider.fetchData(),
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
        ],
      ),
    );
  }
}
