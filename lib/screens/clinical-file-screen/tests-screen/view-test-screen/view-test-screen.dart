import 'dart:io';

import 'package:capsule/models/test.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/components/delete-test-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/components/file-card.dart';
import 'package:capsule/screens/clinical-file-screen/tests-screen/edit-test-screen/edit-test-screen.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ViewTestScreen extends StatelessWidget {
  final Test test;

  const ViewTestScreen(this.test, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('معلومات التحليل'), elevation: 0),
      backgroundColor: MyColors.veryLightGray,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // رأس التحليل
            _buildTestHeader(context),
            const SizedBox(height: 24),

            // معلومات التحليل
            _buildTestInfoCard(context),
            const SizedBox(height: 24),

            // الملف المرفق
            if (test.attachment != null) ...[
              _buildAttachmentSection(context),
              const SizedBox(height: 24),
            ],

            // الأزرار
            _buildActionButtons(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTestHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyColors.warmPeach.withOpacity(0.15),
            MyColors.warmPeach.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColors.warmPeach.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MyColors.warmPeach.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: MyColors.warmPeach.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: FaIcon(
              FontAwesomeIcons.flask,
              size: 64,
              color: MyColors.warmPeach,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            test.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: MyColors.darkNavyBlue,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestInfoCard(BuildContext context) {
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
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'معلومات التحليل',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyColors.darkNavyBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow(context, 'الاسم', test.name, Icons.label_rounded),
            const SizedBox(height: 16),
            Divider(color: MyColors.lightestBlue, height: 1),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'التاريخ',
              DateFormat.yMMMd('ar').format(test.date),
              Icons.calendar_today_rounded,
            ),
            const SizedBox(height: 16),
            Divider(color: MyColors.lightestBlue, height: 1),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'الحالة',
              _getTestStatus(),
              Icons.check_circle_rounded,
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
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: MyColors.darkNavyBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection(BuildContext context) {
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
                    color: MyColors.accentTeal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.attach_file_rounded,
                    color: MyColors.accentTeal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'الملف المرفق',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyColors.darkNavyBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FileCard(File(test.attachment!), isDeletable: false),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // زر التعديل
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditTestScreen(test)),
            ),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('تعديل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryBlue,
              foregroundColor: MyColors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // زر الحذف
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => DeleteTestDialog(test),
              );
            },
            icon: const Icon(Icons.delete_rounded),
            label: const Text('حذف'),
            style: OutlinedButton.styleFrom(
              foregroundColor: MyColors.lightRed,
              side: const BorderSide(color: MyColors.lightRed, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getTestStatus() {
    final now = DateTime.now();
    final difference = now.difference(test.date).inDays;

    if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'أمس';
    } else if (difference <= 30) {
      return 'منذ $difference يوم';
    } else if (difference <= 365) {
      final months = (difference / 30).floor();
      return 'منذ $months شهر';
    } else {
      final years = (difference / 365).floor();
      return 'منذ $years سنة';
    }
  }
}
