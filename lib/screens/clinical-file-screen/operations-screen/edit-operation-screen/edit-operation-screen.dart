import 'package:Capsule/models/operation.dart';
import 'package:Capsule/providers/operations-provider.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/components/custom_input.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditOperationScreen extends StatefulWidget {
  final Operation operation;
  const EditOperationScreen(this.operation, {super.key});

  @override
  State<EditOperationScreen> createState() => _EditOperationScreenState();
}

class _EditOperationScreenState extends State<EditOperationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _operationNameController = TextEditingController();
  final _operationDescriptionController = TextEditingController();

  @override
  void initState() {
    _operationNameController.text = widget.operation.name;
    _operationDescriptionController.text = widget.operation.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: Text('تعديل المرض')),
      backgroundColor: Colors.cyan,
      body: CurvedContainer(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomInput(
                      controller: _operationNameController,
                      labelText: 'اسم المرض',
                      validator: (val) => val == null || val.isEmpty
                          ? 'الرجاء ادخال اسم المرض'
                          : null,
                    ),
                    SizedBox(height: 16),
                    CustomInput(
                      controller: _operationDescriptionController,
                      labelText: 'الوصف',
                      maxLines: 5,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Provider.of<OperationsProvider>(
                                context,
                                listen: false,
                              ).updateOperation(
                                Operation(
                                  id: widget.operation.id,
                                  name: _operationNameController.text,
                                  description:
                                      _operationDescriptionController.text,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          color: Colors.cyan,
                          textColor: Colors.white,
                          child: Text('تعديل'),
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
          ),
        ),
      ),
    );
  }
}
