import 'package:Capsule/screens/landing/components/customImage.dart';
import 'package:Capsule/screens/landing/components/nextButton.dart';
import 'package:Capsule/screens/landing/components/textSection.dart';
import 'package:flutter/material.dart';

class Landing3 extends StatelessWidget {
  final PageController pageController;
  const Landing3(this.pageController, {super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Column(
      children: [
        //skipButton,
        Expanded(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                const CustomImage(imagePath: 'assets/images/landing3.png'),
                SizedBox(height: deviceHeight * 0.05),
                const TextSection(
                  'اشراف الدكتور',
                  'قم بتسجيل تقاريرك الطبية ومتابعتها من اجل انشاء ملف طبي متكامل.',
                ),
              ],
            ),
          ),
        ),
        NextButton(pageController, isLastPage: true),
      ],
    );
  }
}
