import 'package:capsule/models/medicine.dart';
import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/medicine-screen.dart';
import 'package:capsule/screens/clinical-file-screen/view-all-info-screen/view-all-info-screen.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteMedicineDialog extends StatelessWidget {
  final Medicine medicine;
  const DeleteMedicineDialog(this.medicine, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'هل انت متأكد من حذفك لهذا الدواء؟',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
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
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: MyColors.mediumGray),
              ),

            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // زر الحفظ
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MyColors.primaryBlue,
                        MyColors.primaryBlue.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await Provider.of<MedicineReminderProvider>(
                          context,
                          listen: false,
                        ).deleteMedicine(medicine.id!);
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name == MedicineScreen.route ||
                              route.settings.name == ViewAllInfoScreen.route,
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.save_rounded,
                              color: MyColors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'نعم',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // زر الإلغاء
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.lightRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: MyColors.lightRed.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cancel_rounded,
                              color: MyColors.lightRed,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'إلغاء',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: MyColors.lightRed,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
