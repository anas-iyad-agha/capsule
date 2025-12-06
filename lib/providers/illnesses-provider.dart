import 'package:Capsule/local-db/localDB.dart';
import 'package:Capsule/models/illness.dart';
import 'package:flutter/material.dart';

class IllnessesProvider with ChangeNotifier {
  List<Illness> illnesses = [];

  Future getIllnesses() async {
    var response = await Localdb.db!.query('illnesses');
    illnesses.clear();
    response.forEach((illness) => illnesses.add(Illness.fromJson(illness)));
    notifyListeners();
  }

  Future deleteIllness(int id) async {
    int effectedRows = await Localdb.db!.delete('illnesses', where: 'id = $id');
    if (effectedRows != 1) {
      throw Exception('effected rows are not 1');
    }
    await getIllnesses();
  }

  Future addIllness(Illness illness) async {
    await Localdb.db!.insert('illnesses', illness.toJson());
    await getIllnesses();
  }

  Future updateIllness(Illness illness) async {
    await Localdb.db!.update(
      'illnesses',
      illness.toJson(),
      where: 'id = ${illness.id}',
    );
    await getIllnesses();
  }
}
