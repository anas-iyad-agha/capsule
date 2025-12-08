import 'package:Capsule/providers/tests-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/add-test-screen/add-test-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/components/delete-test-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/edit-test-screen/edit-test-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/view-test-screen/view-test-screen.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TestsScreen extends StatefulWidget {
  static const route = '/clinical-file/tests';

  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TestsProvider>(context, listen: false).getTests();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('التحاليل')),
      body: CurvedContainer(
        Consumer<TestsProvider>(
          builder: (_, provider, _) {
            if (provider.tests.isEmpty) {
              return SizedBox.expand(
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
            return ListView.builder(
              itemBuilder: (_, index) => Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewTestScreen(provider.tests[index]),
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
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall!.copyWith(color: Colors.grey),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddTestScreen.route),
        label: Text('اضافة'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
