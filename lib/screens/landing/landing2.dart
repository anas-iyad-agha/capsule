import 'package:Capsule/screens/landing/components/customImage.dart';
import 'package:Capsule/screens/landing/components/nextButton.dart';
import 'package:Capsule/screens/landing/components/skipButton.dart';
import 'package:Capsule/screens/landing/components/textSection.dart';
import 'package:flutter/material.dart';

class Landing2 extends StatelessWidget {
  final PageController pageController;
  const Landing2(this.pageController, {super.key});

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
                const TextSection(
                  'تنبيهات الادوية',
                  'يمكنك ضبط تنبيهات لجميع الادوية وتسجيل الادوية التي استخدمتها.',
                  // 'For all of your medications with a logbook for skipped and confirmed intakes.',
                ),
                SizedBox(height: deviceHeight * 0.05),
                const CustomImage(imagePath: 'assets/images/landing2.png'),
              ],
            ),
          ),
        ),
        NextButton(pageController),
      ],
    );
  }
}
