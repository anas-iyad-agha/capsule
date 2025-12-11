import 'dart:async';

import 'package:Capsule/local-db/localDB.dart';
import 'package:Capsule/notification/notification.dart';
import 'package:Capsule/providers/illnesses-provider.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/providers/operations-provider.dart';
import 'package:Capsule/providers/patien-info-probider.dart';
import 'package:Capsule/providers/tests-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/clinical-file-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/add-illness-screen/add-illness-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/illnesses-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/addMedicineScreen.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/medicine-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/add-operation-screen/add-operation-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/operations-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/add-patient-info-screen/add-patient-info-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/patient-info-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/add-test-screen/add-test-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/tests-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/view-all-info-screen/view-all-info-screen.dart';
import 'package:Capsule/screens/landing/landing-screen.dart';
import 'package:Capsule/screens/main-screen/main-screen.dart';
import 'package:Capsule/screens/reminder-screen/addReminderScreen/addReminderScreen.dart';
import 'package:Capsule/screens/reminder-screen/alarm-screen/alarm-screen.dart';
import 'package:Capsule/screens/reminder-screen/reminders-screen.dart';
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
        ChangeNotifierProvider(create: (_) => PatientInfoProvider()),
        ChangeNotifierProvider(create: (_) => IllnessesProvider()),
        ChangeNotifierProvider(create: (_) => OperationsProvider()),
        ChangeNotifierProvider(create: (_) => TestsProvider()),
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
          RemindersScreen.route: (_) => RemindersScreen(),
          AddReminderScreen.route: (_) => AddReminderScreen(),
          ClinicalFileScreen.route: (_) => ClinicalFileScreen(),
          LandingScreen.route: (_) => LandingScreen(),
          ViewAllInfoScreen.route: (_) => ViewAllInfoScreen(),
          PatientInfoScreen.route: (_) => PatientInfoScreen(),
          AddPatientInfoScreen.route: (_) => AddPatientInfoScreen(),
          IllnessesScreen.route: (_) => IllnessesScreen(),
          AddIllnessScreen.route: (_) => AddIllnessScreen(),
          OperationsScreen.route: (_) => OperationsScreen(),
          AddOperationScreen.route: (_) => AddOperationScreen(),
          TestsScreen.route: (_) => TestsScreen(),
          AddTestScreen.route: (_) => AddTestScreen(),
          MedicineScreen.route: (_) => MedicineScreen(),
          AddMedicineScreen.route: (_) => AddMedicineScreen(),
        },
      ),
    );
  }
}
