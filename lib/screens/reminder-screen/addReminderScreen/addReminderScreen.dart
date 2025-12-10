import 'package:Capsule/models/medicine.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
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
  final _hourlyRepeatController = TextEditingController();

  Medicine? savedSelectedMedicine;

  DateTimeRange<DateTime>? dateRange;
  TimeOfDay? time;

  _selectDateRange() async {
    dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        // Return a new Theme for the date picker only
        return Theme(
          // Copy the current theme and override specific properties
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.white,
            // Define a light color scheme to ensure default text colors are dark and visible
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Header background color (usually primary)
              onPrimary: Colors.white, // Text color on the header
              surface: Colors.white, // The main calendar grid background color
              onSurface: Colors.black, // Day text colors
            ),
            // For Material 3, specifically set the background color and remove any tint overlay
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors
                  .white, // Explicitly set the dialog body background to white
              surfaceTintColor: Colors
                  .transparent, // Prevents a tint from the primary color from appearing
            ),
          ),
          child: child!,
        );
      },
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
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  Row(
                    children: [
                      Expanded(
                        child: CustomInput(
                          keyboardType: TextInputType.number,
                          controller: _repeatController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          suffixText: 'يوم/أيام',
                          labelText: 'التكرار',
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'الرجاء ملئ التكرار';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: CustomInput(
                          keyboardType: TextInputType.number,
                          controller: _hourlyRepeatController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          suffixText: 'ساعة/ساعات',
                          labelText: 'التكرار',
                          validator: (val) {
                            if (val != null &&
                                double.tryParse(val) != null &&
                                double.parse(val) > 24) {
                              return 'يجب ادخال عدد اقل من 24';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
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
                                  int.tryParse(_hourlyRepeatController.text) ??
                                      23,
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
        ),
      ),
    );
  }
}
