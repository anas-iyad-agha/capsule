import 'package:Capsule/models/operation.dart';
import 'package:Capsule/providers/operations-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOperationScreen extends StatefulWidget {
  static const route = '/clinical-file/operations/add';
  const AddOperationScreen({super.key});

  @override
  State<AddOperationScreen> createState() => _AddOperationScreenState();
}

class _AddOperationScreenState extends State<AddOperationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اضافة عملية')),
      body: Column(
        children: [
          CurvedContainer(
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomInput(
                    controller: _nameController,
                    labelText: 'الاسم',
                    validator: (val) =>
                        val == null || val.isEmpty ? 'الرجاء ملئ الاسم' : null,
                  ),
                  SizedBox(height: 32),
                  CustomInput(
                    controller: _descriptionController,
                    labelText: 'الوصف',
                    maxLines: 5,
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var provider = Provider.of<OperationsProvider>(
                              context,
                              listen: false,
                            );
                            provider.addOperation(
                              Operation(
                                name: _nameController.text,
                                description: _descriptionController.text,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        color: Colors.cyan,
                        textColor: Colors.white,
                        child: Text('إضافة'),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          side: WidgetStatePropertyAll(
                            BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
