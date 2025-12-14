import 'package:capsule/models/medicine.dart';
import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:capsule/screens/reminder-screen/addReminderScreen/components/customDropDownMenu.dart';
import 'package:capsule/theme.dart';
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

  DateTimeRange? dateRange;
  TimeOfDay? time;

  _selectDateRange() async {
    final selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: MyColors.white,
            colorScheme: const ColorScheme.light(
              primary: MyColors.primaryBlue,
              onPrimary: MyColors.white,
              surface: MyColors.white,
              onSurface: MyColors.darkNavyBlue,
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: MyColors.white,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedRange != null) {
      setState(() {
        dateRange = selectedRange;
      });
    }
  }

  void _selectTime() async {
    final currentTime = TimeOfDay.now();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (selectedTime != null) {
      setState(() {
        time = selectedTime;
      });
    }
  }

  @override
  void dispose() {
    _medicineController.dispose();
    _labelController.dispose();
    _repeatController.dispose();
    _hourlyRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منبه')),
      backgroundColor: MyColors.veryLightGray,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // اختيار الدواء
                CustomDropdownMenu(
                  controller: _medicineController,
                  selectedMedicine: savedSelectedMedicine,
                ),
                const SizedBox(height: 24),

                // اختيار النطاق الزمني
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
                      prefixIcon: const Icon(Icons.calendar_today_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // اختيار الوقت
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
                      labelText: time == null ? 'الوقت' : time!.format(context),
                      prefixIcon: const Icon(Icons.schedule_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // التكرار اليومي والساعي
                Row(
                  children: [
                    Expanded(
                      child: CustomInput(
                        keyboardType: TextInputType.number,
                        controller: _repeatController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        suffixText: 'يوم',
                        labelText: 'التكرار اليومي',
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'مطلوب';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomInput(
                        keyboardType: TextInputType.number,
                        controller: _hourlyRepeatController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        suffixText: 'ساعة',
                        labelText: 'التكرار الساعي',
                        validator: (val) {
                          if (val != null &&
                              double.tryParse(val) != null &&
                              double.parse(val) > 24) {
                            return 'أقل من 24';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // الوصف
                CustomInput(
                  labelText: 'وصف أو ملاحظة',
                  controller: _labelController,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // أزرار الحفظ والإلغاء
                Consumer<MedicineReminderProvider>(
                  builder: (_, provider, __) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            provider.medicines.forEach((element) {
                              if (element.name == _medicineController.text) {
                                setState(() {
                                  savedSelectedMedicine = element;
                                });
                              }
                            });
                            if (_formKey.currentState!.validate()) {
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
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('إضافة'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          label: const Text('إلغاء'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: MyColors.lightRed,
                            side: const BorderSide(color: MyColors.lightRed),
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
    );
  }
}
