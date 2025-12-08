import 'package:Capsule/models/medicine.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:Capsule/screens/reminder-screen/addReminderScreen/components/customDropDownMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddReminderScreen extends StatefulWidget {
  static const route = '/reminders/add';

  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicineController = TextEditingController();
  final _labelController = TextEditingController();
  final _repeatController = TextEditingController(text: '1');

  Medicine? savedSelectedMedicine;

  DateTimeRange<DateTime>? dateRange;
  TimeOfDay? time;

  _selectDateRange() async {
    dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    setState(() {});
  }

  void _selectTime() async {
    final currentTime = TimeOfDay.now();
    time = await showTimePicker(context: context, initialTime: currentTime);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منبه')),
      body: CurvedContainer(
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomDropdownMenu(
                controller: _medicineController,
                selectedMedicine: savedSelectedMedicine,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _selectDateRange,
                child: TextFormField(
                  enabled: false,
                  validator: (_) {
                    if (dateRange == null) {
                      return 'الرجاء اختيار النطاق الزمني';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: dateRange == null
                        ? 'النطاق الزمني'
                        : '${DateFormat.yMMMd('ar').format(dateRange!.start)} - ${DateFormat.yMMMd('ar').format(dateRange!.end)}',
                    labelStyle: const TextStyle(color: Colors.black54),
                    suffixIcon: const Icon(Icons.alarm),
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectTime,
                child: TextFormField(
                  enabled: false,
                  validator: (_) {
                    if (time == null) {
                      return 'الرجاء اختيار الوقت';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: time == null
                        ? 'الوقت'
                        : TimeOfDay(
                            hour: time!.hour,
                            minute: time!.minute,
                          ).format(context),
                    labelStyle: const TextStyle(color: Colors.black54),
                    suffixIcon: const Icon(Icons.alarm),
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomInput(
                keyboardType: TextInputType.number,
                controller: _repeatController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixText: 'يوم/أيام',
                labelText: 'التكرار',
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'الرجاء ملئ التكرار';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomInput(labelText: 'وصف', controller: _labelController),
              const SizedBox(height: 24),
              Consumer<MedicineReminderProvider>(
                builder: (_, provider, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          provider.medicines.forEach((element) {
                            if (element.name == _medicineController.text) {
                              setState(() {
                                savedSelectedMedicine = element;
                              });
                            }
                          });
                          if (_formKey.currentState!.validate()) {
                            var provider =
                                Provider.of<MedicineReminderProvider>(
                                  context,
                                  listen: false,
                                );
                            Navigator.of(context).pop();
                            await provider.registerReminders(
                              _labelController.text,
                              savedSelectedMedicine!,
                              time!,
                              dateRange!,
                              int.parse(_repeatController.text),
                            );
                            await provider.fetchData();
                          }
                        },
                        color: Colors.cyan,
                        textColor: Colors.white,
                        child: Text('اضافة'),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
