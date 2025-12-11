import 'package:Capsule/models/illness.dart';
import 'package:Capsule/providers/illnesses-provider.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/providers/operations-provider.dart';
import 'package:Capsule/providers/patien-info-probider.dart';
import 'package:Capsule/providers/tests-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/components/delete-illness-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/edit-illness-screen/edit-illness-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/view-illness-screen/view-illness-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/components/medicineListItem.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/components/delete-operation-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/edit-operation-screen/edit-operation-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/view-operation-screen/view-operation-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/add-patient-info-screen/add-patient-info-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/components/add-patient-info-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/patient-info-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/components/delete-test-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/edit-test-screen/edit-test-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/view-test-screen/view-test-screen.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewAllInfoScreen extends StatefulWidget {
  static const route = '/clinical-file/view-all-info';
  const ViewAllInfoScreen({super.key});

  @override
  State<ViewAllInfoScreen> createState() => _ViewAllInfoScreenState();
}

class _ViewAllInfoScreenState extends State<ViewAllInfoScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int returnedValue = await Provider.of<PatientInfoProvider>(
        context,
        listen: false,
      ).getPatientInfo();

      Provider.of<MedicineReminderProvider>(context, listen: false).fetchData();
      Provider.of<IllnessesProvider>(context, listen: false).getIllnesses();
      Provider.of<OperationsProvider>(context, listen: false).getOperations();
      Provider.of<TestsProvider>(context, listen: false).getTests();

      if (returnedValue != 0) {
        showDialog(context: context, builder: (_) => AddPatientInfoDialog());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: Text('جميع المعلومات')),
      body: Column(
        children: [
          CurvedContainer(
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                // patient info
                SliverToBoxAdapter(
                  child: Consumer<PatientInfoProvider>(
                    builder: (context, provider, _) {
                      if (provider.patientInfo == null) {
                        return Column(
                          children: [
                            Icon(Icons.person_off_outlined, size: width / 4),
                            Text('لم يتم ادخال معلومات المريض'),
                            SizedBox(height: 16),
                            MaterialButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AddPatientInfoScreen.route,
                              ),
                              padding: EdgeInsets.all(16),
                              color: Colors.cyan,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'ادخال معلومات المريض',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Icon(Icons.person_outline, size: width / 3),
                          Text(
                            provider.patientInfo!.fullName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(provider.patientInfo!.job),
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'المؤشرات الطبية الحيوية',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      MedicalVitalsInfo(
                                        name: 'الوزن',
                                        value: provider.patientInfo!.weight
                                            .toString(),
                                        unit: 'Kg',
                                      ),
                                      MedicalVitalsInfo(
                                        name: 'الطول',
                                        value: provider.patientInfo!.height
                                            .toString(),
                                        unit: 'Cm',
                                      ),
                                      MedicalVitalsInfo(
                                        name: 'فصيلة الدم',
                                        value: provider.patientInfo!.bloodType,
                                        unit: '',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'المعلومات الشخصية',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  Divider(color: Colors.grey, height: 32),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'الجنس',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        provider.patientInfo!.isMale
                                            ? 'ذكر'
                                            : 'أنثى',
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.grey, height: 32),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'الحالة الاجتماعية',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(provider.patientInfo!.familyStatus),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'الحالة الطبية',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  Divider(color: Colors.grey, height: 32),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'الحساسيات',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(provider.patientInfo!.allergies),
                                    ],
                                  ),
                                  Divider(color: Colors.grey, height: 32),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'التدخين',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        provider.patientInfo!.isSmoking
                                            ? 'نعم'
                                            : 'لا',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // medicine info
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Divider(height: 64),
                      Text(
                        'الأدوية',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
                Consumer<MedicineReminderProvider>(
                  builder: (context, provider, widget) {
                    if (provider.medicines.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.medication_outlined),
                            Text('لم يتم اضافة ادوية'),
                          ],
                        ),
                      );
                    }
                    var previuseMedicine = provider.medicines
                        .where(
                          (medicine) =>
                              medicine.endDate.isBefore(DateTime.now()),
                        )
                        .toList();
                    var currentMedicine = provider.medicines
                        .where(
                          (medicine) =>
                              medicine.endDate.isAfter(DateTime.now()),
                        )
                        .toList();
                    return SliverList.list(
                      children: [
                        Text('الادوية الحالية'),
                        currentMedicine.isNotEmpty
                            ? ListView.separated(
                                itemBuilder: (_, index) =>
                                    MedicineListItem(currentMedicine[index]),
                                separatorBuilder: (_, _) =>
                                    SizedBox(height: 16),
                                itemCount: currentMedicine.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.medication_outlined),
                                    Text('لا يوجد ادوية حالية'),
                                  ],
                                ),
                              ),
                        SizedBox(height: 32),
                        Text('الادوية السابقة'),
                        previuseMedicine.isNotEmpty
                            ? ListView.separated(
                                itemBuilder: (_, index) =>
                                    MedicineListItem(previuseMedicine[index]),
                                separatorBuilder: (_, _) =>
                                    SizedBox(height: 16),
                                itemCount: previuseMedicine.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.medication_outlined),
                                    Text('لا يوجد ادوية سابقة'),
                                  ],
                                ),
                              ),
                      ],
                    );
                  },
                ),
                // illnesses info
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Divider(height: 64),
                      Text(
                        'الأمراض',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
                Consumer<IllnessesProvider>(
                  builder: (_, provider, _) {
                    var currentIllnesses = provider.illnesses
                        .where(
                          (illness) => illness.type == Illness.illnessTypes[0],
                        )
                        .toList();

                    var tempraryIllnesses = provider.illnesses
                        .where(
                          (illness) => illness.type == Illness.illnessTypes[1],
                        )
                        .toList();

                    var healedIllnesses = provider.illnesses
                        .where(
                          (illness) => illness.type == Illness.illnessTypes[2],
                        )
                        .toList();

                    var hereditaryIllness = provider.illnesses
                        .where(
                          (illness) => illness.type == Illness.illnessTypes[3],
                        )
                        .toList();
                    return SliverList.list(
                      children: [
                        SizedBox(height: 32),
                        Text(
                          Illness.illnessTypes[0],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IllnessList(currentIllnesses),
                        SizedBox(height: 32),
                        Text(
                          Illness.illnessTypes[1],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IllnessList(tempraryIllnesses),
                        SizedBox(height: 32),
                        Text(
                          Illness.illnessTypes[2],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IllnessList(healedIllnesses),
                        SizedBox(height: 32),
                        Text(
                          Illness.illnessTypes[3],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IllnessList(hereditaryIllness),
                      ],
                    );
                  },
                ),
                // operations info
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Divider(height: 64),
                      Text(
                        'العمليات',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
                Consumer<OperationsProvider>(
                  builder: (_, provider, _) {
                    if (provider.operations.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.heartCircleCheck),
                            SizedBox(height: 8),
                            Text('لا يوجد عمليات'),
                          ],
                        ),
                      );
                    }
                    return SliverList.builder(
                      itemBuilder: (_, index) => Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewOperationScreen(
                                  provider.operations[index],
                                ),
                              ),
                            );
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.operations[index].name),
                              provider.operations[index].description.isNotEmpty
                                  ? Text(
                                      provider.operations[index].description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.grey),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          leading: Text((index + 1).toString()),
                          trailing: MenuAnchor(
                            menuChildren: [
                              MenuItemButton(
                                leadingIcon: Icon(Icons.edit_outlined),
                                child: Text('تعديل'),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditOperationScreen(
                                      provider.operations[index],
                                    ),
                                  ),
                                ),
                              ),
                              MenuItemButton(
                                leadingIcon: Icon(Icons.delete_outline),
                                child: Text('حذف'),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => DeleteOperationDialog(
                                    provider.operations[index],
                                  ),
                                ),
                              ),
                            ],
                            builder: (_, controller, _) => IconButton(
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              icon: Icon(Icons.more_vert),
                            ),
                          ),
                        ),
                      ),
                      itemCount: provider.operations.length,
                    );
                  },
                ),
                // tests info
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Divider(height: 64),
                      Text(
                        'التحاليل',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
                Consumer<TestsProvider>(
                  builder: (_, provider, _) {
                    if (provider.tests.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.flask),
                            SizedBox(height: 16),
                            Text('لا يوجد تحاليل'),
                          ],
                        ),
                      );
                    }
                    return SliverList.builder(
                      itemBuilder: (_, index) => Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ViewTestScreen(provider.tests[index]),
                              ),
                            );
                          },
                          minVerticalPadding: 16,
                          leading: Text((index + 1).toString()),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.tests[index].name),
                              Text(
                                DateFormat.yMMMd(
                                  'ar',
                                ).format(provider.tests[index].date),
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: MenuAnchor(
                            menuChildren: [
                              MenuItemButton(
                                leadingIcon: Icon(Icons.edit_outlined),
                                child: Text('تعديل'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditTestScreen(provider.tests[index]),
                                    ),
                                  );
                                },
                              ),
                              MenuItemButton(
                                leadingIcon: Icon(Icons.delete_outline),
                                child: Text('حذف'),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) =>
                                      DeleteTestDialog(provider.tests[index]),
                                ),
                              ),
                            ],
                            builder: (_, controller, _) => IconButton(
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              icon: Icon(Icons.more_vert),
                            ),
                          ),
                        ),
                      ),
                      itemCount: provider.tests.length,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IllnessList extends StatelessWidget {
  final List<Illness> illnesses;
  const IllnessList(this.illnesses, {super.key});

  @override
  Widget build(BuildContext context) {
    if (illnesses.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(FontAwesomeIcons.heartCircleCheck),
          Text('لا يوجد امراض'),
        ],
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) => IllnessListItem(illnesses[index]),
      itemCount: illnesses.length,
    );
  }
}

class IllnessListItem extends StatelessWidget {
  final Illness illness;
  const IllnessListItem(this.illness, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ViewIllnessScreen(illness)),
          );
        },
        trailing: MenuAnchor(
          menuChildren: [
            MenuItemButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditIllnessScreen(illness),
                ),
              ),
              leadingIcon: Icon(Icons.edit_outlined),
              child: Text('تعديل'),
            ),
            MenuItemButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DeleteIllnessDialog(illness),
                );
              },
              leadingIcon: Icon(Icons.delete_outline),
              child: Text('حذف'),
            ),
          ],
          builder: (_, controller, _) => IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: Icon(Icons.more_vert),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(illness.name),
            illness.description.isNotEmpty
                ? Text(
                    illness.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
