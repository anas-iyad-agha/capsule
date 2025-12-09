import 'package:Capsule/screens/landing/landing1.dart';
import 'package:Capsule/screens/landing/landing2.dart';
import 'package:Capsule/screens/landing/landing3.dart';
import 'package:Capsule/theme.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  static const route = '/landing';

  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final pageController = PageController();

  final colors = <Color>[MyColors.landing1, Colors.cyan, Colors.blueAccent];

  Color pageColor = MyColors.landing1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 25),
        color: pageColor,
        duration: Duration(milliseconds: 200),
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              pageColor = colors[index];
            });
          },
          children: [
            Landing1(pageController),
            Landing2(pageController),
            Landing3(pageController),
          ],
        ),
      ),
    );
  }
}
