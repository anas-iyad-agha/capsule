import 'package:capsule/models/illness.dart';
import 'package:capsule/providers/illnesses-provider.dart';
import 'package:capsule/screens/clinical-file-screen/illnesses-screen/add-illness-screen/add-illness-screen.dart';
import 'package:capsule/screens/clinical-file-screen/illnesses-screen/components/delete-illness-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/illnesses-screen/edit-illness-screen/edit-illness-screen.dart';
import 'package:capsule/screens/clinical-file-screen/illnesses-screen/view-illness-screen/view-illness-screen.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class IllnessesScreen extends StatefulWidget {
  static const route = '/clinical-file/illnesses';

  const IllnessesScreen({super.key});

  @override
  State<IllnessesScreen> createState() => _IllnessesScreenState();
}

class _IllnessesScreenState extends State<IllnessesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IllnessesProvider>(context, listen: false).getIllnesses();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.veryLightGray,
      appBar: AppBar(title: const Text('الأمراض'), elevation: 0),
      body: Consumer<IllnessesProvider>(
        builder: (_, provider, _) {
          if (provider.illnesses.isEmpty) {
            return _buildEmptyState(context);
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

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // الأمراض الحالية
              _buildIllnessSection(
                context,
                'الأمراض الحالية',
                currentIllnesses,
                MyColors.lightRed,
              ),

              // الأمراض المؤقتة
              _buildIllnessSection(
                context,
                'الأمراض المؤقتة',
                temporaryIllnesses,
                MyColors.warmPeach,
              ),

              // الأمراض المشفاة
              _buildIllnessSection(
                context,
                'الأمراض المشفاة',
                healedIllnesses,
                MyColors.accentTeal,
              ),

              // الأمراض الوراثية
              _buildIllnessSection(
                context,
                'الأمراض الوراثية',
                hereditaryIllness,
                MyColors.mediumBlue,
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddIllnessScreen.route),
        icon: const Icon(Icons.add_rounded),
        label: const Text('أضف مرض'),
      ),
    );
  }

  SliverToBoxAdapter _buildIllnessSection(
    BuildContext context,
    String title,
    List<Illness> illnesses,
    Color color,
  ) {
    if (illnesses.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _buildEmptyIllnessSection(title, color),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس القسم
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.health_and_safety_rounded,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyColors.darkNavyBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    illnesses.length.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // قائمة الأمراض
            ...illnesses.asMap().entries.map((entry) {
              int index = entry.key;
              Illness illness = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: IllnessCard(
                  illness: illness,
                  color: color,
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditIllnessScreen(illness),
                    ),
                  ),
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (context) => DeleteIllnessDialog(illness),
                    );
                  },
                  onView: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewIllnessScreen(illness),
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 12),
            if (illnesses.isNotEmpty)
              Divider(color: MyColors.lightestBlue, height: 1),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyIllnessSection(String title, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: color.withOpacity(0.4),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MyColors.mediumGray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'لا توجد أمراض في هذه الفئة',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: MyColors.lightGray),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  color: MyColors.accentTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: MyColors.accentTeal.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: FaIcon(
                  FontAwesomeIcons.heartCircleCheck,
                  size: 80,
                  color: MyColors.accentTeal,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'لا توجد أمراض مسجلة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: MyColors.darkNavyBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'هذا أمر جيد! سجل أي أمراض عند الحاجة',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MyColors.mediumGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AddIllnessScreen.route),
                icon: const Icon(Icons.add_rounded),
                label: const Text('إضافة مرض'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== IllnessCard ====================
class IllnessCard extends StatelessWidget {
  final Illness illness;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const IllnessCard({
    required this.illness,
    required this.color,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onView,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // الأيقونة
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // المعلومات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      illness.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: MyColors.darkNavyBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (illness.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          illness.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: MyColors.mediumGray),
                        ),
                      ),
                  ],
                ),
              ),

              // القائمة
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.visibility_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('عرض'),
                      ],
                    ),
                    onTap: onView,
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('تعديل'),
                      ],
                    ),
                    onTap: onEdit,
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
                    onTap: onDelete,
                  ),
                ],
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: MyColors.mediumGray,
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
