import 'package:Capsule/screens/landing/components/customImage.dart';
import 'package:Capsule/screens/landing/components/nextButton.dart';
import 'package:Capsule/screens/landing/components/skipButton.dart';
import 'package:Capsule/screens/landing/components/textSection.dart';
import 'package:flutter/material.dart';

class Landing1 extends StatelessWidget {
  final PageController pageController;
  const Landing1(this.pageController, {super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Column(
      children: [
        const SkipButton(),
        Expanded(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                const CustomImage(imagePath: 'assets/images/landing1.png'),
                SizedBox(height: deviceHeight * 0.05),
                const TextSection(
                  'تطبيق كبسولة',
                  'تطبيق لإدارة الملف السريري وتنبيهات مواعيد الدواء.',
                ),
              ],
            ),
          ),
        ),
        NextButton(pageController),
      ],
    );
  }
}
