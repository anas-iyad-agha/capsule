import 'package:capsule/providers/patien-info-probider.dart';
import 'package:capsule/screens/clinical-file-screen/patient-info-screen/add-patient-info-screen/add-patient-info-screen.dart';
import 'package:capsule/screens/clinical-file-screen/patient-info-screen/components/add-patient-info-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/patient-info-screen/edit-patient-info-screen/edit-patient-info-screen.dart';
import 'package:capsule/theme.dart';
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
        showDialog(
          context: context,
          builder: (_) => const AddPatientInfoDialog(),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معلومات المريض'),
        elevation: 0,
        actions: [
          Consumer<PatientInfoProvider>(
            builder: (context, provider, _) {
              if (provider.patientInfo != null) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditPatientInfoScreen(provider.patientInfo!),
                      ),
                    ),
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: 'تعديل المعلومات',
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      backgroundColor: MyColors.veryLightGray,
      body: Consumer<PatientInfoProvider>(
        builder: (context, provider, _) {
          if (provider.patientInfo == null) {
            return _buildEmptyState(context);
          }
          return _buildPatientInfo(context, provider);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MyColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: MyColors.primaryBlue.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.person_off_rounded,
                  size: 80,
                  color: MyColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'لم يتم إدخال معلومات المريض',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: MyColors.darkNavyBlue,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'قم بإضافة معلومات المريض الأساسية لمتابعة الحالة الصحية',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MyColors.mediumGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AddPatientInfoScreen.route),
                icon: const Icon(Icons.add_rounded),
                label: const Text('إضافة المعلومات'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfo(BuildContext context, PatientInfoProvider provider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // رأس المريض
            _buildPatientHeader(context, provider),
            const SizedBox(height: 24),

            // المؤشرات الحيوية
            _buildVitalsSection(context, provider),
            const SizedBox(height: 20),

            // المعلومات الشخصية
            _buildPersonalInfoSection(context, provider),
            const SizedBox(height: 20),

            // الحالة الطبية
            _buildMedicalStatusSection(context, provider),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader(
    BuildContext context,
    PatientInfoProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyColors.primaryBlue.withOpacity(0.12),
            MyColors.lightSkyBlue.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MyColors.primaryBlue.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryBlue.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.primaryBlue.withOpacity(0.2),
                  MyColors.lightSkyBlue.withOpacity(0.15),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: MyColors.primaryBlue.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              size: 80,
              color: MyColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            provider.patientInfo!.fullName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: MyColors.darkNavyBlue,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            provider.patientInfo!.job,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: MyColors.mediumGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsSection(
    BuildContext context,
    PatientInfoProvider provider,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColors.lightRed.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: MyColors.lightRed,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'المؤشرات الحيوية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyColors.darkNavyBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVitalCard(
                  context,
                  'الوزن',
                  provider.patientInfo!.weight.toString(),
                  'كغ',
                  MyColors.primaryBlue,
                  Icons.scale_rounded,
                ),
                _buildVitalCard(
                  context,
                  'الطول',
                  provider.patientInfo!.height.toString(),
                  'سم',
                  MyColors.accentTeal,
                  Icons.height_rounded,
                ),
                _buildVitalCard(
                  context,
                  'فصيلة الدم',
                  provider.patientInfo!.bloodType,
                  '',
                  MyColors.lightRed,
                  Icons.bloodtype_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(
    BuildContext context,
    String label,
    String value,
    String unit,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: MyColors.mediumGray,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (unit.isNotEmpty)
                    TextSpan(
                      text: ' $unit',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: MyColors.mediumGray,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(
    BuildContext context,
    PatientInfoProvider provider,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColors.primaryBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_rounded,
                    color: MyColors.primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'المعلومات الشخصية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyColors.darkNavyBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'الجنس',
              provider.patientInfo!.isMale ? 'ذكر' : 'أنثى',
              Icons.wc_rounded,
            ),
            const SizedBox(height: 16),
            _buildDivider(),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'الحالة الاجتماعية',
              provider.patientInfo!.familyStatus,
              Icons.groups_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalStatusSection(
    BuildContext context,
    PatientInfoProvider provider,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColors.lightRed.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.health_and_safety_rounded,
                    color: MyColors.lightRed,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'الحالة الطبية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyColors.darkNavyBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'الحساسيات',
              provider.patientInfo!.allergies,
              Icons.warning_rounded,
            ),
            const SizedBox(height: 16),
            _buildDivider(),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'التدخين',
              provider.patientInfo!.isSmoking ? 'نعم' : 'لا',
              Icons.smoke_free_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: MyColors.primaryBlue, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: MyColors.mediumGray),
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: MyColors.darkNavyBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: MyColors.lightestBlue, height: 1, thickness: 1);
  }
}

// ==================== MedicalVitalsInfo (محسّنة) ====================
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: MyColors.mediumGray,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            text: value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: MyColors.darkNavyBlue,
              fontWeight: FontWeight.w700,
            ),
            children: [
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: MyColors.mediumGray),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
