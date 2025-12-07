import 'package:Capsule/local-db/localDB.dart';
import 'package:Capsule/models/operation.dart';
import 'package:flutter/material.dart';

class OperationsProvider with ChangeNotifier {
  List<Operation> operations = [];

  Future getOperations() async {
    var response = await Localdb.db!.query('operations');
    operations.clear();
    response.forEach(
      (opration) => operations.add(Operation.fromJson(opration)),
    );
    notifyListeners();
  }

  Future addOperation(Operation operation) async {
    await Localdb.db!.insert('operations', operation.toJson());
    await getOperations();
  }

  Future deleteOperation(int id) async {
    int effectedRows = await Localdb.db!.delete(
      'operations',
      where: 'id = $id',
    );
    if (effectedRows != 1) {
      throw Exception('effected rows are not 1');
    }
    await getOperations();
  }

  Future updateOperation(Operation operation) async {
    int effectedRows = await Localdb.db!.update(
      'operations',
      operation.toJson(),
      where: 'id = ${operation.id}',
    );
    if (effectedRows != 1) {
      throw Exception('effected rows are not 1');
    }
    await getOperations();
  }
}
