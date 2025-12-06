import 'package:Capsule/screens/clinical-file-screen/clinical-file-screen.dart';
import 'package:Capsule/screens/main-screen/components/service-navigation-card.dart';
import 'package:Capsule/screens/main-screen/components/today-schedule.dart';
import 'package:Capsule/screens/medicine/medicine-screen.dart';
import 'package:Capsule/screens/reminder-screen/reminders-screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const route = '/';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F8F7),
      appBar: AppBar(backgroundColor: Color(0xffF6F8F7)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(flex: 2, child: TodaySchedule()),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ServiceNavigationCard(
                          route: MedicineScreen.route,
                          title: 'أدويتي',
                          description: 'تابع جميع ادويتك',
                          icon: Icons.medication_outlined,
                        ),
                      ),
                      Expanded(
                        child: ServiceNavigationCard(
                          route: RemindersScreen.route,
                          title: 'التنبيهات',
                          icon: Icons.notifications_on_outlined,
                          description: 'أدر تنبيهاتك',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ServiceNavigationCard(
                          route: ClinicalFileScreen.route,
                          title: 'الملف السريري',
                          icon: Icons.bar_chart_outlined,
                          description: 'تابع ملف المريض ومعلوماته الصحية',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
