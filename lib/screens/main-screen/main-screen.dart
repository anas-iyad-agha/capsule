import 'package:Capsule/screens/about-screen/about-screen.dart';
import 'package:Capsule/screens/main-screen/components/service-navigation-card.dart';
import 'package:Capsule/screens/main-screen/components/today-schedule.dart';
import 'package:Capsule/screens/medicine/medicine-screen.dart';
import 'package:Capsule/screens/reminder-screen/reminders-screen.dart';
import 'package:Capsule/screens/reports-screen/reportsScreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const route = '/';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F8F7),
      appBar: AppBar(
        backgroundColor: Color(0xffF6F8F7),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AboutScreen.route),
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(flex: 2, child: TodaySchedule()),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 1.6,

                physics: NeverScrollableScrollPhysics(),
                children: [
                  ServiceNavigationCard(
                    route: MedicineScreen.route,
                    title: 'أدويتي',
                    description: 'تابع جميع ادويتك',
                    icon: Icons.medication_outlined,
                    color: Colors.teal,
                  ),
                  ServiceNavigationCard(
                    route: RemindersScreen.route,
                    title: 'التنبيهات',
                    icon: Icons.notifications_on_outlined,
                    color: Colors.greenAccent,
                    description: 'أدر تنبيهاتك',
                  ),
                  ServiceNavigationCard(
                    route: ReportsScreen.route,
                    title: 'التقارير',
                    icon: Icons.bar_chart_outlined,
                    color: Colors.cyan,
                    description: 'تفقد تقاريرك الطبية',
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
