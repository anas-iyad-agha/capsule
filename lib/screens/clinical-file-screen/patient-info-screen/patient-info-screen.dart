import 'package:Capsule/providers/patien-info-probider.dart';
import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/add-patient-info-screen/add-patient-info-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/components/add-patient-info-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/edit-patient-info-screen/edit-patient-info-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientInfoScreen extends StatefulWidget {
  static const route = '/clinical-file/patient-info';
  const PatientInfoScreen({super.key});

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int returnedValue = await Provider.of<PatientInfoProvider>(
        context,
        listen: false,
      ).getPatientInfo();

      if (returnedValue != 0) {
        showDialog(context: context, builder: (_) => AddPatientInfoDialog());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Color(0xffF6F8F8),
      appBar: AppBar(
        title: Text('معلومات المريض'),
        actions: [
          Consumer<PatientInfoProvider>(
            builder: (context, provider, _) {
              if (provider.patientInfo != null) {
                return IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditPatientInfoScreen(provider.patientInfo!),
                    ),
                  ),
                  icon: Icon(Icons.edit_outlined),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
      body: Consumer<PatientInfoProvider>(
        builder: (context, provider, _) {
          if (provider.patientInfo == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_outlined, size: width / 4),
                  Text('لم يتم ادخال معلومات المريض'),
                  SizedBox(height: 16),
                  MaterialButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AddPatientInfoScreen.route,
                    ),
                    padding: EdgeInsets.all(16),
                    color: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ادخال معلومات المريض',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: width / 2),
                Text(
                  provider.patientInfo!.fullName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(provider.patientInfo!.job),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المؤشرات الطبية الحيوية',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MedicalVitalsInfo(
                              name: 'الوزن',
                              value: provider.patientInfo!.weight.toString(),
                              unit: 'Kg',
                            ),
                            MedicalVitalsInfo(
                              name: 'الطول',
                              value: provider.patientInfo!.height.toString(),
                              unit: 'Cm',
                            ),
                            MedicalVitalsInfo(
                              name: 'فصيلة الدم',
                              value: provider.patientInfo!.bloodType,
                              unit: '',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المعلومات الشخصية',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Divider(color: Colors.grey, height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('الجنس', style: TextStyle(color: Colors.grey)),
                            Text(provider.patientInfo!.isMale ? 'ذكر' : 'أنثى'),
                          ],
                        ),
                        Divider(color: Colors.grey, height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الحالة الاجتماعية',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(provider.patientInfo!.familyStatus),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الحالة الطبية',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Divider(color: Colors.grey, height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الحساسيات',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(provider.patientInfo!.allergies),
                          ],
                        ),
                        Divider(color: Colors.grey, height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'التدخين',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              provider.patientInfo!.isSmoking ? 'نعم' : 'لا',
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
        },
      ),
    );
  }
}

class MedicalVitalsInfo extends StatelessWidget {
  final String name;
  final String value;
  final String unit;
  const MedicalVitalsInfo({
    required this.name,
    required this.value,
    required this.unit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
        ),
        Text.rich(
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              TextSpan(
                text: unit,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
