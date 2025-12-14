import 'package:capsule/screens/clinical-file-screen/clinical-file-screen.dart';
import 'package:capsule/screens/main-screen/components/service-navigation-card.dart';
import 'package:capsule/screens/main-screen/components/today-schedule.dart';
import 'package:capsule/screens/reminder-screen/reminders-screen.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const route = '/';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFFE1F5FE)],
            colors: [
              Color.fromARGB(255, 168, 213, 252), // أغمق قليلًا
              Color.fromARGB(255, 174, 213, 252),
              Color.fromARGB(255, 173, 208, 243),
              Color.fromARGB(255, 194, 220, 238),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              Expanded(flex: 5, child: TodaySchedule()),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ServiceNavigationCard(
                            route: RemindersScreen.route,
                            title: 'التنبيهات',
                            icon: Icons.notifications_on_outlined,
                            description: 'أدر تنبيهاتك',
                            color: MyColors.primaryBlue,
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
                            icon: Icons.insert_drive_file_outlined,
                            description: 'تابع ملف المريض ومعلوماته الصحية',
                            color: MyColors.accentTeal,
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
      ),
    );
  }
}
