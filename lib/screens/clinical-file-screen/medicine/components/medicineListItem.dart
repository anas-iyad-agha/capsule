import 'package:capsule/models/medicine.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/components/delete-medicine-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/edit-medicine-screen/edit-medicine-screen.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/view-medicine-screen/view-medicine-screen.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';

class MedicineListItem extends StatelessWidget {
  final Medicine medicine;

  const MedicineListItem(this.medicine, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewMedicineScreen(medicine)),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // الأيقونة
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MyColors.accentTeal.withOpacity(0.2),
                      MyColors.accentTeal.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: MyColors.accentTeal.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: MyColors.accentTeal,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),

              // المعلومات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // اسم الدواء
                    Text(
                      medicine.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: MyColors.darkNavyBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // الوصف
                    if (medicine.description.isNotEmpty)
                      Text(
                        medicine.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: MyColors.mediumGray,
                        ),
                      ),

                    // مدة الاستخدام
                    const SizedBox(height: 6),
                    _buildPeriodInfo(context),
                  ],
                ),
              ),

              // القائمة المنسدلة
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(
                          Icons.visibility_rounded,
                          size: 18,
                          color: MyColors.primaryBlue,
                        ),
                        SizedBox(width: 8),
                        Text('عرض'),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewMedicineScreen(medicine),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: MyColors.lightSkyBlue,
                        ),
                        SizedBox(width: 8),
                        Text('تعديل'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditMedicineScreen(medicine),
                        ),
                      );
                    },
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
                        builder: (context) => DeleteMedicineDialog(medicine),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodInfo(BuildContext context) {
    final isActive = medicine.endDate.isAfter(DateTime.now());
    final formattedDate = _formatDate(medicine.endDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? MyColors.accentTeal.withOpacity(0.15)
            : MyColors.lightGray.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle_rounded : Icons.history_rounded,
            size: 14,
            color: isActive ? MyColors.accentTeal : MyColors.mediumGray,
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'ينتهي: $formattedDate' : 'انتهى: $formattedDate',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive ? MyColors.accentTeal : MyColors.mediumGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'منذ ${(-difference)} يوم';
    } else if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'غداً';
    } else if (difference <= 7) {
      return 'بعد $difference أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// ==================== نسخة بديلة مع تفاصيل إضافية ====================
class MedicineListItemExtended extends StatelessWidget {
  final Medicine medicine;

  const MedicineListItemExtended(this.medicine, {super.key});

  @override
  Widget build(BuildContext context) {
    final isActive = medicine.endDate.isAfter(DateTime.now());

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewMedicineScreen(medicine)),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف الأول: الأيقونة والاسم والقائمة
              Row(
                children: [
                  // الأيقونة
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MyColors.accentTeal.withOpacity(0.2),
                          MyColors.accentTeal.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: MyColors.accentTeal.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.medication_rounded,
                      color: MyColors.accentTeal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // الاسم والحالة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: MyColors.darkNavyBlue,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? MyColors.accentTeal.withOpacity(0.2)
                                : MyColors.lightGray.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isActive ? 'نشط' : 'منتهي',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: isActive
                                      ? MyColors.accentTeal
                                      : MyColors.mediumGray,
                                  fontWeight: FontWeight.w600,
                                ),
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
                            Icon(
                              Icons.visibility_rounded,
                              size: 18,
                              color: MyColors.primaryBlue,
                            ),
                            SizedBox(width: 8),
                            Text('عرض'),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewMedicineScreen(medicine),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: MyColors.lightSkyBlue,
                            ),
                            SizedBox(width: 8),
                            Text('تعديل'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditMedicineScreen(medicine),
                            ),
                          );
                        },
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
                            Text(
                              'حذف',
                              style: TextStyle(color: MyColors.lightRed),
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                DeleteMedicineDialog(medicine),
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
                ],
              ),

              // الوصف إذا كان موجوداً
              if (medicine.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  medicine.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: MyColors.mediumGray),
                ),
              ],

              // مدة الاستخدام
              const SizedBox(height: 8),
              _buildPeriodInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodInfo(BuildContext context) {
    final isActive = medicine.endDate.isAfter(DateTime.now());
    final formattedDate = _formatDate(medicine.endDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? MyColors.accentTeal.withOpacity(0.1)
            : MyColors.lightGray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle_rounded : Icons.history_rounded,
            size: 16,
            color: isActive ? MyColors.accentTeal : MyColors.mediumGray,
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'ينتهي: $formattedDate' : 'انتهى: $formattedDate',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive ? MyColors.accentTeal : MyColors.mediumGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'منذ ${(-difference)} يوم';
    } else if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'غداً';
    } else if (difference <= 7) {
      return 'بعد $difference أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
