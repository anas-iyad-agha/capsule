import 'package:capsule/providers/tests-provider.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/add-test-screen/add-test-screen.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/components/delete-test-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/edit-test-screen/edit-test-screen.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/view-test-screen/view-test-screen.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TestsScreen extends StatefulWidget {
  static const route = '/clinical-file/tests';

  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TestsProvider>(context, listen: false).getTests();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.veryLightGray,
      appBar: AppBar(title: const Text('التحاليل والفحوصات'), elevation: 0),
      body: Consumer<TestsProvider>(
        builder: (_, provider, _) {
          if (provider.tests.isEmpty) {
            return _buildEmptyState(context);
          }

          // ترتيب التحاليل من الأحدث إلى الأقدم
          final sortedTests = List<dynamic>.from(provider.tests)
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) => TestCard(
              test: sortedTests[index],
              index: index + 1,
              onView: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewTestScreen(sortedTests[index]),
                ),
              ),
              onEdit: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditTestScreen(sortedTests[index]),
                ),
              ),
              onDelete: () => showDialog(
                context: context,
                builder: (_) => DeleteTestDialog(sortedTests[index]),
              ),
            ),
            itemCount: provider.tests.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddTestScreen.route),
        icon: const Icon(Icons.add_rounded),
        label: const Text('أضف تحليل'),
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
                  color: MyColors.warmPeach.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: MyColors.warmPeach.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: FaIcon(
                  FontAwesomeIcons.flask,
                  size: 80,
                  color: MyColors.warmPeach,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'لا توجد تحاليل مسجلة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: MyColors.darkNavyBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'سجل نتائج تحاليلك لمتابعة صحتك',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MyColors.mediumGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AddTestScreen.route),
                icon: const Icon(Icons.add_rounded),
                label: const Text('إضافة أول تحليل'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TestCard ====================
class TestCard extends StatelessWidget {
  final dynamic test;
  final int index;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TestCard({
    required this.test,
    required this.index,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isRecentTest = _isRecentTest(test.date);

    return GestureDetector(
      onTap: onView,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // الرقم مع الأيقونة
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MyColors.warmPeach.withOpacity(0.2),
                      MyColors.warmPeach.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: MyColors.warmPeach.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.flask,
                    color: MyColors.warmPeach,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // المعلومات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            test.name,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: MyColors.darkNavyBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isRecentTest)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.warmPeach.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'جديد',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: MyColors.warmPeach,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: MyColors.mediumGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.yMMMd('ar').format(test.date),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: MyColors.mediumGray),
                        ),
                      ],
                    ),
                    if (test.attachment != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.attach_file_rounded,
                              size: 14,
                              color: MyColors.accentTeal,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'يوجد مرفق',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: MyColors.accentTeal),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // القائمة المنسدلة
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

  bool _isRecentTest(DateTime date) {
    final now = DateTime.now();
    return now.difference(date).inDays <= 7;
  }
}
