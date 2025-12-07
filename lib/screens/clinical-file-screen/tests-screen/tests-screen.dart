import 'package:flutter/material.dart';

class TestsScreen extends StatelessWidget {
  static const route = '/clinical-file/tests';

  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('التحاليل')));
  }
}
