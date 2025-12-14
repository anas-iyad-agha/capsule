import 'package:capsule/screens/clinical-file-screen/illnesses-screen/illnesses-screen.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/medicine-screen.dart';
import 'package:capsule/screens/clinical-file-screen/operations-screen/operations-screen.dart';
import 'package:capsule/screens/clinical-file-screen/patient-info-screen/patient-info-screen.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/tests-screen.dart';
import 'package:capsule/screens/clinical-file-screen/view-all-info-screen/view-all-info-screen.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClinicalFileScreen extends StatefulWidget {
  static const route = '/clinical-file';
  const ClinicalFileScreen({super.key});

  @override
  State<ClinicalFileScreen> createState() => _ClinicalFileScreenState();
}

class _ClinicalFileScreenState extends State<ClinicalFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.veryLightGray,
      appBar: AppBar(title: const Text('الملف السريري'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // بطاقة معلومات المريض
              _buildClinicalCard(
                context: context,
                route: PatientInfoScreen.route,
                icon: Icons.person_rounded,
                title: 'معلومات المريض',
                description: 'عرض البيانات الشخصية والصحية',
                color: MyColors.primaryBlue,
              ),
              const SizedBox(height: 12),
              // بطاقة الأدوية
              _buildClinicalCard(
                context: context,
                route: MedicineScreen.route,
                icon: FontAwesomeIcons.pills,
                title: 'الأدوية',
                description: 'قائمة الأدوية الحالية والسابقة',
                color: MyColors.accentTeal,
              ),
              const SizedBox(height: 12),
              // بطاقة الأمراض
              _buildClinicalCard(
                context: context,
                route: IllnessesScreen.route,
                icon: FontAwesomeIcons.virus,
                title: 'الأمراض',
                description: 'سجل الأمراض والتشخيصات',
                color: MyColors.lightRed,
              ),
              const SizedBox(height: 12),
              // بطاقة العمليات
              _buildClinicalCard(
                context: context,
                route: OperationsScreen.route,
                icon: FontAwesomeIcons.stethoscope,
                title: 'العمليات الجراحية',
                description: 'سجل العمليات والإجراءات الطبية',
                color: MyColors.mediumBlue,
              ),
              const SizedBox(height: 12),
              // بطاقة التحاليل
              _buildClinicalCard(
                context: context,
                route: TestsScreen.route,
                icon: FontAwesomeIcons.flask,
                title: 'التحاليل والفحوصات',
                description: 'نتائج التحاليل والفحوصات الطبية',
                color: MyColors.warmPeach,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, ViewAllInfoScreen.route);
        },
        icon: const Icon(Icons.file_present_rounded),
        label: const Text('عرض الملف كاملاً'),
      ),
    );
  }

  Widget _buildClinicalCard({
    required BuildContext context,
    required String route,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shadowColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.15), width: 1),
          ),
          child: Row(
            children: [
              // الأيقونة
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              // العنوان والوصف
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MyColors.darkNavyBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: MyColors.mediumGray,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // السهم
              Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
