import 'package:capsule/providers/operations-provider.dart';
import 'package:capsule/screens/clinical-file-screen/operations-screen/add-operation-screen/add-operation-screen.dart';
import 'package:capsule/screens/clinical-file-screen/operations-screen/components/delete-operation-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/operations-screen/edit-operation-screen/edit-operation-screen.dart';
import 'package:capsule/screens/clinical-file-screen/operations-screen/view-operation-screen/view-operation-screen.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OperationsScreen extends StatefulWidget {
  static const route = '/clinical-file/operations';

  const OperationsScreen({super.key});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OperationsProvider>(context, listen: false).getOperations();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.veryLightGray,
      appBar: AppBar(title: const Text('العمليات الجراحية'), elevation: 0),
      body: Consumer<OperationsProvider>(
        builder: (_, provider, _) {
          if (provider.operations.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) => OperationCard(
              operation: provider.operations[index],
              index: index + 1,
              onEdit: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditOperationScreen(provider.operations[index]),
                ),
              ),
              onDelete: () => showDialog(
                context: context,
                builder: (_) =>
                    DeleteOperationDialog(provider.operations[index]),
              ),
              onView: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ViewOperationScreen(provider.operations[index]),
                ),
              ),
            ),
            itemCount: provider.operations.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddOperationScreen.route),
        icon: const Icon(Icons.add_rounded),
        label: const Text('أضف عملية'),
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
                  color: MyColors.mediumBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: MyColors.mediumBlue.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: FaIcon(
                  FontAwesomeIcons.heartCircleCheck,
                  size: 80,
                  color: MyColors.mediumBlue,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'لا توجد عمليات مسجلة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: MyColors.darkNavyBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'سيتم عرض العمليات الجراحية هنا',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MyColors.mediumGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AddOperationScreen.route),
                icon: const Icon(Icons.add_rounded),
                label: const Text('إضافة عملية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== OperationCard ====================
class OperationCard extends StatelessWidget {
  final dynamic operation;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const OperationCard({
    required this.operation,
    required this.index,
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
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // الرقم
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MyColors.mediumBlue.withOpacity(0.2),
                      MyColors.mediumBlue.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: MyColors.mediumBlue.withOpacity(0.3),
                  ),
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
              const SizedBox(width: 12),

              // المعلومات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      operation.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: MyColors.darkNavyBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (operation.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          operation.description,
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
