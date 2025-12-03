import 'package:Capsule/providers/reports-provider.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:Capsule/screens/reports-screen/components/report-list-item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  static const route = '/reports';
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ReportsProvider>(context, listen: false).fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text('التقارير'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                Provider.of<ReportsProvider>(
                  context,
                  listen: false,
                ).fetchData(status: value);
              },
              decoration: InputDecoration(
                hint: Text('البحث'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          CurvedContainer(
            Consumer<ReportsProvider>(
              builder: (context, provider, widget) {
                if (provider.state == ReportsProviderState.loading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (provider.reports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_copy_outlined),
                        Text('لا يوجد تقارير'),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemBuilder: (context, index) =>
                      ReportListItem(provider.reports[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: provider.reports.length,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_chart_rounded),
        label: Text('أضف تقرير'),
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.of(context).pushNamed('/reports/add');
        },
      ),
    );
  }
}
