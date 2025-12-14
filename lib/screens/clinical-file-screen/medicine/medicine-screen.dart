import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/add-medicine-screen/addMedicineScreen.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/components/medicineListItem.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineScreen extends StatefulWidget {
  static const route = '/clinical-file/medicine';

  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  String searchQuery = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicineReminderProvider>(context, listen: false).fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.veryLightGray,
      appBar: AppBar(title: const Text('أدويتي'), elevation: 0),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                Provider.of<MedicineReminderProvider>(
                  context,
                  listen: false,
                ).searchMedicine(value);
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن دواء...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                          });
                          Provider.of<MedicineReminderProvider>(
                            context,
                            listen: false,
                          ).searchMedicine('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // قائمة الأدوية
          Expanded(
            child: Consumer<MedicineReminderProvider>(
              builder: (context, provider, widget) {
                if (provider.medicines.isEmpty) {
                  return _buildEmptyState(context);
                }

                var currentMedicine = provider.medicines
                    .where(
                      (medicine) => medicine.endDate.isAfter(DateTime.now()),
                    )
                    .toList();

                var previousMedicine = provider.medicines
                    .where(
                      (medicine) => medicine.endDate.isBefore(DateTime.now()),
                    )
                    .toList();

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // الأدوية الحالية
                    if (currentMedicine.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: MyColors.accentTeal.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.local_pharmacy_rounded,
                                  color: MyColors.accentTeal,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'الأدوية الحالية',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: MyColors.darkNavyBlue,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.accentTeal.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  currentMedicine.length.toString(),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: MyColors.accentTeal,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList.separated(
                          itemBuilder: (_, index) =>
                              MedicineListItem(currentMedicine[index]),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemCount: currentMedicine.length,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ] else
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildEmptyMedicineSection(
                            'لا توجد أدوية حالية',
                            'أضف أدويتك الحالية لمتابعتها',
                          ),
                        ),
                      ),

                    // الأدوية السابقة
                    if (previousMedicine.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: MyColors.lightGray.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.history_rounded,
                                  color: MyColors.mediumGray,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'الأدوية السابقة',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: MyColors.mediumGray,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.mediumGray.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  previousMedicine.length.toString(),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: MyColors.mediumGray,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList.separated(
                          itemBuilder: (_, index) =>
                              MedicineListItem(previousMedicine[index]),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemCount: previousMedicine.length,
                        ),
                      ),
                    ] else
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildEmptyMedicineSection(
                            'لا توجد أدوية سابقة',
                            'سيتم عرض أدويتك السابقة هنا',
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddMedicineScreen.route),
        icon: const Icon(Icons.add_rounded),
        label: const Text('أضف دواء'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MyColors.accentTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: MyColors.accentTeal.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  size: 80,
                  color: MyColors.accentTeal,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'لم يتم إضافة أدوية بعد',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: MyColors.darkNavyBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'أضف أدويتك لتتمكن من متابعتها',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MyColors.mediumGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AddMedicineScreen.route),
                icon: const Icon(Icons.add_rounded),
                label: const Text('إضافة أول دواء'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMedicineSection(String title, String subtitle) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.medication_outlined,
                size: 48,
                color: MyColors.accentTeal.withOpacity(0.4),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MyColors.mediumGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: MyColors.lightGray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
