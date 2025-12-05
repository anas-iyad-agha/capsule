import 'dart:async';

import 'package:Capsule/local-db/localDB.dart';
import 'package:Capsule/notification/notification.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/providers/reports-provider.dart';
import 'package:Capsule/screens/about-screen/about-screen.dart';
import 'package:Capsule/screens/landing/landing-screen.dart';
import 'package:Capsule/screens/main-screen/main-screen.dart';
import 'package:Capsule/screens/medicine/add-medicine-screen/addMedicineScreen.dart';
import 'package:Capsule/screens/medicine/medicine-screen.dart';
import 'package:Capsule/screens/reminder-screen/addReminderScreen/addReminderScreen.dart';
import 'package:Capsule/screens/reminder-screen/alarm-screen/alarm-screen.dart';
import 'package:Capsule/screens/reminder-screen/reminders-screen.dart';
import 'package:Capsule/screens/reports-screen/add-report-screen/addReportScreen.dart';
import 'package:Capsule/screens/reports-screen/reportsScreen.dart';
import 'package:Capsule/theme.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

Future<void> init() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await <Permission>[
    Permission.notification,
    Permission.reminders,
    Permission.audio,
    Permission.scheduleExactAlarm,
  ].request();
  await Alarm.init();

  await await Localdb.init();
  await Notifications.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? ringSubscription;

  @override
  void initState() {
    super.initState();

    ringSubscription = Alarm.ringStream.stream.listen((alarmSettings) {
      navigateToRingScreen(alarmSettings);
    });
  }

  void navigateToRingScreen(AlarmSettings alarmSettings) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => AlarmScreen(alarmSettings)),
    );
  }

  @override
  void dispose() {
    ringSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicineReminderProvider()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: defaultTheme,
        title: 'Capsule',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('ar')],
        locale: Locale('ar'),
        initialRoute: LandingScreen.route,
        routes: {
          MainScreen.route: (_) => MainScreen(),
          AboutScreen.route: (_) => AboutScreen(),
          MedicineScreen.route: (_) => MedicineScreen(),
          AddMedicineScreen.route: (_) => AddMedicineScreen(),
          RemindersScreen.route: (_) => RemindersScreen(),
          AddReminderScreen.route: (_) => AddReminderScreen(),
          ReportsScreen.route: (_) => ReportsScreen(),
          AddReportScreen.route: (_) => AddReportScreen(),
          LandingScreen.route: (_) => LandingScreen(),
        },
      ),
    );
  }
}
