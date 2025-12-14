import 'package:capsule/models/illness.dart';
import 'package:capsule/providers/illnesses-provider.dart';
import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/providers/operations-provider.dart';
import 'package:capsule/providers/patien-info-probider.dart';
import 'package:capsule/providers/tests-provider.dart';
import 'package:capsule/screens/clinical-file-screen/illnesses-screen/components/delete-illness-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/illnesses-screen/edit-illness-screen/edit-illness-screen.dart';
import 'package:capsule/screens/clinical-file-screen/illnesses-screen/view-illness-screen/view-illness-screen.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/components/medicineListItem.dart';
import 'package:capsule/screens/clinical-file-screen/operations-screen/components/delete-operation-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/operations-screen/edit-operation-screen/edit-operation-screen.dart';
import 'package:capsule/screens/clinical-file-screen/operations-screen/view-operation-screen/view-operation-screen.dart';
import 'package:capsule/screens/clinical-file-screen/patient-info-screen/add-patient-info-screen/add-patient-info-screen.dart';
import 'package:capsule/screens/clinical-file-screen/patient-info-screen/components/add-patient-info-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/components/delete-test-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/edit-test-screen/edit-test-screen.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/view-test-screen/view-test-screen.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewAllInfoScreen extends StatefulWidget {
  static const route = '/clinical-file/view-all-info';
  const ViewAllInfoScreen({super.key});

  @override
  State<ViewAllInfoScreen> createState() => _ViewAllInfoScreenState();
}

class _ViewAllInfoScreenState extends State<ViewAllInfoScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int returnedValue = await Provider.of<PatientInfoProvider>(
        context,
        listen: false,
      ).getPatientInfo();

      Provider.of<MedicineReminderProvider>(context, listen: false).fetchData();
      Provider.of<IllnessesProvider>(context, listen: false).getIllnesses();
      Provider.of<OperationsProvider>(context, listen: false).getOperations();
      Provider.of<TestsProvider>(context, listen: false).getTests();

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('ملفي الصحي الكامل'), elevation: 0),
      backgroundColor: MyColors.veryLightGray,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // معلومات المريض
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<PatientInfoProvider>(
                builder: (context, provider, _) {
                  if (provider.patientInfo == null) {
                    return _buildEmptyPatientInfo(context);
                  }
                  return _buildPatientInfoSection(
                    context,
                    provider,
                    screenWidth,
                  );
                },
              ),
            ),
          ),

          // الأدوية
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildSectionHeader(
                context: context,
                title: 'الأدوية',
                icon: Icons.medication_rounded,
                color: MyColors.accentTeal,
              ),
            ),
          ),
          Consumer<MedicineReminderProvider>(
            builder: (context, provider, widget) {
              if (provider.medicines.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildEmptyState(
                      icon: Icons.medication_outlined,
                      label: 'لم يتم إضافة أدوية',
                      color: MyColors.accentTeal,
                    ),
                  ),
                );
              }

              var currentMedicine = provider.medicines
                  .where((medicine) => medicine.endDate.isAfter(DateTime.now()))
                  .toList();
              var previousMedicine = provider.medicines
                  .where(
                    (medicine) => medicine.endDate.isBefore(DateTime.now()),
                  )
                  .toList();

              return SliverList(
                delegate: SliverChildListDelegate([
                  if (currentMedicine.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Text(
                        'الأدوية الحالية',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: MyColors.darkNavyBlue,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) =>
                            MedicineListItem(currentMedicine[index]),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: currentMedicine.length,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (previousMedicine.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Text(
                        'الأدوية السابقة',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: MyColors.mediumGray,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) =>
                            MedicineListItem(previousMedicine[index]),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: previousMedicine.length,
                      ),
                    ),
                  ],
                ]),
              );
            },
          ),

          // الأمراض
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: _buildSectionHeader(
                context: context,
                title: 'الأمراض',
                icon: Icons.health_and_safety_rounded,
                color: MyColors.lightRed,
              ),
            ),
          ),
          Consumer<IllnessesProvider>(
            builder: (_, provider, _) {
              if (provider.illnesses.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildEmptyState(
                      icon: Icons.favorite_rounded,
                      label: 'لا توجد أمراض مسجلة',
                      color: MyColors.accentTeal,
                    ),
                  ),
                );
              }

              var currentIllnesses = provider.illnesses
                  .where((illness) => illness.type == Illness.illnessTypes[0])
                  .toList();
              var temporaryIllnesses = provider.illnesses
                  .where((illness) => illness.type == Illness.illnessTypes[1])
                  .toList();
              var healedIllnesses = provider.illnesses
                  .where((illness) => illness.type == Illness.illnessTypes[2])
                  .toList();
              var hereditaryIllness = provider.illnesses
                  .where((illness) => illness.type == Illness.illnessTypes[3])
                  .toList();

              return SliverList(
                delegate: SliverChildListDelegate([
                  if (currentIllnesses.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: _buildSubsectionHeader(
                        context,
                        Illness.illnessTypes[0],
                        MyColors.lightRed,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IllnessList(currentIllnesses),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (temporaryIllnesses.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: _buildSubsectionHeader(
                        context,
                        Illness.illnessTypes[1],
                        MyColors.warmPeach,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IllnessList(temporaryIllnesses),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (healedIllnesses.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: _buildSubsectionHeader(
                        context,
                        Illness.illnessTypes[2],
                        MyColors.accentTeal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IllnessList(healedIllnesses),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (hereditaryIllness.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: _buildSubsectionHeader(
                        context,
                        Illness.illnessTypes[3],
                        MyColors.mediumBlue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IllnessList(hereditaryIllness),
                    ),
                    const SizedBox(height: 20),
                  ],
                ]),
              );
            },
          ),

          // العمليات
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: _buildSectionHeader(
                context: context,
                title: 'العمليات الجراحية',
                icon: Icons.medical_services_rounded,
                color: MyColors.mediumBlue,
              ),
            ),
          ),
          Consumer<OperationsProvider>(
            builder: (_, provider, _) {
              if (provider.operations.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildEmptyState(
                      icon: Icons.health_and_safety_outlined,
                      label: 'لا توجد عمليات مسجلة',
                      color: MyColors.mediumBlue,
                    ),
                  ),
                );
              }
              return SliverList.builder(
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: OperationListItem(
                    operation: provider.operations[index],
                    index: index + 1,
                  ),
                ),
                itemCount: provider.operations.length,
              );
            },
          ),

          // التحاليل
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: _buildSectionHeader(
                context: context,
                title: 'التحاليل والفحوصات',
                icon: Icons.science_rounded,
                color: MyColors.warmPeach,
              ),
            ),
          ),
          Consumer<TestsProvider>(
            builder: (_, provider, _) {
              if (provider.tests.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildEmptyState(
                      icon: Icons.science_outlined,
                      label: 'لا توجد تحاليل مسجلة',
                      color: MyColors.warmPeach,
                    ),
                  ),
                );
              }
              return SliverList.builder(
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TestListItem(
                    test: provider.tests[index],
                    index: index + 1,
                  ),
                ),
                itemCount: provider.tests.length,
              );
            },
          ),

          // مسافة نهائية
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildEmptyPatientInfo(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_off_rounded,
                size: 48,
                color: MyColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'لم يتم إدخال معلومات المريض',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: MyColors.darkNavyBlue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AddPatientInfoScreen.route),
              icon: const Icon(Icons.add_rounded),
              label: const Text('إضافة المعلومات'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoSection(
    BuildContext context,
    PatientInfoProvider provider,
    double screenWidth,
  ) {
    return Column(
      children: [
        // رأس المريض
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyColors.primaryBlue.withOpacity(0.1),
                MyColors.lightSkyBlue.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MyColors.primaryBlue.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MyColors.primaryBlue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 64,
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
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MyColors.mediumGray),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // المؤشرات الحيوية
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: MyColors.lightRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'المؤشرات الحيوية',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MyColors.darkNavyBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
        ),
        const SizedBox(height: 20),

        // المعلومات الشخصية
        _buildInfoCard(
          context: context,
          title: 'المعلومات الشخصية',
          icon: Icons.info_rounded,
          color: MyColors.primaryBlue,
          items: [
            InfoItem(
              'الجنس',
              provider.patientInfo!.isMale ? 'ذكر' : 'أنثى',
              Icons.wc_rounded,
            ),
            InfoItem(
              'الحالة الاجتماعية',
              provider.patientInfo!.familyStatus,
              Icons.groups_rounded,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // الحالة الطبية
        _buildInfoCard(
          context: context,
          title: 'الحالة الطبية',
          icon: Icons.health_and_safety_rounded,
          color: MyColors.lightRed,
          items: [
            InfoItem(
              'الحساسيات',
              provider.patientInfo!.allergies,
              Icons.warning_rounded,
            ),
            InfoItem(
              'التدخين',
              provider.patientInfo!.isSmoking ? 'نعم' : 'لا',
              Icons.smoke_free_rounded,
            ),
          ],
        ),
      ],
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

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required List<InfoItem> items,
  }) {
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
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyColors.darkNavyBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.asMap().entries.map((entry) {
              int idx = entry.key;
              InfoItem item = entry.value;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            item.icon,
                            color: MyColors.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: MyColors.mediumGray),
                          ),
                        ],
                      ),

                      Text(
                        item.value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: MyColors.darkNavyBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (idx < items.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: MyColors.lightestBlue, height: 1),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: MyColors.darkNavyBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSubsectionHeader(
    BuildContext context,
    String title,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: color.withOpacity(0.4)),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MyColors.mediumGray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoItem {
  final String label;
  final String value;
  final IconData icon;

  InfoItem(this.label, this.value, this.icon);
}

// ==================== IllnessList ====================
class IllnessList extends StatelessWidget {
  final List<Illness> illnesses;
  const IllnessList(this.illnesses, {super.key});

  @override
  Widget build(BuildContext context) {
    if (illnesses.isEmpty) {
      return const SizedBox();
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) => IllnessListItem(illnesses[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: illnesses.length,
    );
  }
}

class IllnessListItem extends StatelessWidget {
  final Illness illness;
  const IllnessListItem(this.illness, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ViewIllnessScreen(illness)),
          );
        },
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: MyColors.lightRed.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.health_and_safety_rounded,
            color: MyColors.lightRed,
            size: 20,
          ),
        ),
        title: Text(
          illness.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: MyColors.darkNavyBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: illness.description.isNotEmpty
            ? Text(
                illness.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: MyColors.mediumGray),
              )
            : null,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.edit_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('تعديل'),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditIllnessScreen(illness),
                ),
              ),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(
                    Icons.delete_rounded,
                    size: 18,
                    color: MyColors.lightRed,
                  ),
                  SizedBox(width: 8),
                  Text('حذف', style: TextStyle(color: MyColors.lightRed)),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => DeleteIllnessDialog(illness),
                );
              },
            ),
          ],
          icon: Icon(
            Icons.more_vert_rounded,
            color: MyColors.mediumGray,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class OperationListItem extends StatelessWidget {
  final dynamic operation;
  final int index;

  const OperationListItem({
    required this.operation,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ViewOperationScreen(operation)),
          );
        },
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: MyColors.mediumBlue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              index.toString(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: MyColors.mediumBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        title: Text(
          operation.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: MyColors.darkNavyBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: operation.description.isNotEmpty
            ? Text(
                operation.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: MyColors.mediumGray),
              )
            : null,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.visibility_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('عرض'),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewOperationScreen(operation),
                ),
              ),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.edit_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('تعديل'),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditOperationScreen(operation),
                ),
              ),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(
                    Icons.delete_rounded,
                    size: 18,
                    color: MyColors.lightRed,
                  ),
                  SizedBox(width: 8),
                  Text('حذف', style: TextStyle(color: MyColors.lightRed)),
                ],
              ),
              onTap: () => showDialog(
                context: context,
                builder: (_) => DeleteOperationDialog(operation),
              ),
            ),
          ],
          icon: Icon(
            Icons.more_vert_rounded,
            color: MyColors.mediumGray,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ==================== TestListItem ====================
class TestListItem extends StatelessWidget {
  final dynamic test;
  final int index;

  const TestListItem({required this.test, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ViewTestScreen(test)),
          );
        },
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: MyColors.warmPeach.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              index.toString(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: MyColors.warmPeach,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        title: Text(
          test.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: MyColors.darkNavyBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          DateFormat.yMMMd('ar').format(test.date),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: MyColors.mediumGray),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.visibility_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('عرض'),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewTestScreen(test)),
              ),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.edit_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('تعديل'),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditTestScreen(test)),
              ),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(
                    Icons.delete_rounded,
                    size: 18,
                    color: MyColors.lightRed,
                  ),
                  SizedBox(width: 8),
                  Text('حذف', style: TextStyle(color: MyColors.lightRed)),
                ],
              ),
              onTap: () => showDialog(
                context: context,
                builder: (_) => DeleteTestDialog(test),
              ),
            ),
          ],
          icon: Icon(
            Icons.more_vert_rounded,
            color: MyColors.mediumGray,
            size: 20,
          ),
        ),
      ),
    );
  }
}
