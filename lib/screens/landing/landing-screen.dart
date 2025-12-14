import 'package:capsule/screens/landing/landing1.dart';
import 'package:capsule/screens/landing/landing2.dart';
import 'package:capsule/screens/landing/landing3.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  static const route = '/landing';
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final pageController = PageController();
  int currentPage = 0;

  final gradients = <List<Color>>[
    // Gradient للصفحة الأولى - أزرق
    [Color.fromARGB(180, 63, 140, 255), Color.fromARGB(180, 27, 53, 88)],
    // Gradient للصفحة الثانية - تيركواز
    [Color.fromARGB(180, 131, 203, 200), Color.fromARGB(180, 34, 122, 146)],
    // Gradient للصفحة الثالثة - أزرق داكن
    [Color.fromARGB(180, 27, 53, 88), Color.fromARGB(180, 63, 140, 255)],
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView للشاشات
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              Landing1(pageController),
              Landing2(pageController),
              Landing3(pageController),
            ],
          ),

          // مؤشرات الصفحات في الأسفل
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? MyColors.white
                        : MyColors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
