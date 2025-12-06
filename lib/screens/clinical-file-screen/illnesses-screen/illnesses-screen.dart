import 'package:Capsule/models/illness.dart';
import 'package:Capsule/providers/illnesses-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/add-illness-screen/add-illness-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/components/delete-illness-dialog.dart';
import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/edit-illness-screen/edit-illness-screen.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class IllnessesScreen extends StatelessWidget {
  static const route = '/clinical-file/illnesses';

  const IllnessesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(title: Text('الأمراض')),
      body: CurvedContainer(
        Consumer<IllnessesProvider>(
          builder: (_, provider, _) {
            var currentIllnesses = provider.illnesses
                .where((illness) => illness.type == Illness.illnessTypes[0])
                .toList();

            var tempraryIllnesses = provider.illnesses
                .where((illness) => illness.type == Illness.illnessTypes[1])
                .toList();

            var healedIllnesses = provider.illnesses
                .where((illness) => illness.type == Illness.illnessTypes[2])
                .toList();

            var hereditaryIllness = provider.illnesses
                .where((illness) => illness.type == Illness.illnessTypes[3])
                .toList();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 32)),
                SliverToBoxAdapter(
                  child: Text(
                    Illness.illnessTypes[0],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IllnessList(currentIllnesses),
                SliverToBoxAdapter(child: Divider(height: 64)),
                SliverToBoxAdapter(
                  child: Text(
                    Illness.illnessTypes[1],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IllnessList(tempraryIllnesses),
                SliverToBoxAdapter(child: Divider(height: 64)),
                SliverToBoxAdapter(
                  child: Text(
                    Illness.illnessTypes[2],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IllnessList(healedIllnesses),
                SliverToBoxAdapter(child: Divider(height: 64)),
                SliverToBoxAdapter(
                  child: Text(
                    Illness.illnessTypes[3],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IllnessList(hereditaryIllness),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddIllnessScreen.route),
        backgroundColor: Colors.cyan,
        icon: Icon(Icons.add),
        label: Text('اضافة'),
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
      return SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              FaIcon(FontAwesomeIcons.heartCircleCheck),
              Text('لا يوجد امراض'),
            ],
          ),
        ),
      );
    }
    return SliverList.builder(
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
        title: Text(illness.name),
      ),
    );
  }
}
