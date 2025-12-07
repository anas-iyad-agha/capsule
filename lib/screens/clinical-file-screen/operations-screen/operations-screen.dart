import 'package:Capsule/providers/operations-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/add-operation-screen/add-operation-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/components/delete-operation-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/edit-operation-screen/edit-operation-screen.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OperationsScreen extends StatefulWidget {
  static const route = '/clinical-file/operations';

  const OperationsScreen({super.key});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OperationsProvider>(context, listen: false).getOperations();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(title: Text('العمليات')),
      body: CurvedContainer(
        Consumer<OperationsProvider>(
          builder: (_, provider, _) {
            if (provider.operations.isEmpty) {
              return SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.heartCircleCheck),
                    SizedBox(height: 8),
                    Text('لا يوجد عمليات'),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (_, index) => Card(
                child: ListTile(
                  title: Text(provider.operations[index].name),
                  leading: Text(provider.operations[index].id.toString()),
                  trailing: MenuAnchor(
                    menuChildren: [
                      MenuItemButton(
                        leadingIcon: Icon(Icons.edit_outlined),
                        child: Text('تعديل'),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditOperationScreen(provider.operations[index]),
                          ),
                        ),
                      ),
                      MenuItemButton(
                        leadingIcon: Icon(Icons.delete_outline),
                        child: Text('حذف'),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) =>
                              DeleteOperationDialog(provider.operations[index]),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddOperationScreen.route),
        backgroundColor: Colors.cyan,
        label: Text('اضافة'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
