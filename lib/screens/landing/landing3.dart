import 'package:Capsule/screens/landing/components/nextButton.dart';
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
        Expanded(
          child: Center(
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.2,
                  child: Image.asset('assets/images/IUST-logo.png'),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'تطبيق الملف السريري وتنبيهات مواعيد الدواء',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'مشروع تخرج - كلية الصيدلة',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'باشراف: الدكتور محمد المنتصر',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'كل الشكر والتقدير لدعمكم وإشرافكم',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(color: Colors.white),
                    ),
                    // const CustomImage(imagePath: 'assets/images/landing3.png'),
                    // SizedBox(height: deviceHeight * 0.05),
                    // const TextSection(
                    //   'اشراف الدكتور',
                    //   'قم بتسجيل تقاريرك الطبية ومتابعتها من اجل انشاء ملف طبي متكامل.',
                    // ),
                  ],
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
