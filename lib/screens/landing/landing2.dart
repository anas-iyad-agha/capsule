import 'package:capsule/screens/landing/components/nextButton.dart';
import 'package:capsule/screens/landing/components/skipButton.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';

class Landing2 extends StatelessWidget {
  final PageController pageController;
  const Landing2(this.pageController, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(200, 131, 203, 200),
            Color.fromARGB(220, 34, 122, 146),
          ],
        ),
      ),
      child: Stack(
        children: [
          // خلفية الصورة الشفافة
          Positioned(
            bottom: -100,
            left: -100,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: screenSize.width * 1.5,
                height: screenSize.height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.white,
                ),
              ),
            ),
          ),

          // الشعار في الخلفية
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/IUST-logo.png',
                fit: BoxFit.contain,
                height: screenSize.height * 0.6,
              ),
            ),
          ),

          // المحتوى الرئيسي
          Padding(
            padding: EdgeInsets.fromLTRB(16, screenSize.height * 0.05, 16, 24),
            child: Column(
              children: [
                // زر الاختصار
                const SkipButton(),

                // المحتوى المركزي
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // إطار دائري للشعار
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors.white.withOpacity(0.15),
                              border: Border.all(
                                color: MyColors.white.withOpacity(0.4),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: MyColors.darkNavyBlue.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColors.white.withOpacity(0.1),
                                  border: Border.all(
                                    color: MyColors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: Image.asset(
                                    'assets/images/IUST-MEDI-FIle-LOGO.png',
                                    fit: BoxFit.contain,
                                    // color: MyColors.white,
                                    // colorBlendMode: BlendMode.lighten,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // العنوان
                          Text(
                            'الجامعة الدولية الخاصة',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  color: MyColors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            'للعلوم والتقنية',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: MyColors.white.withOpacity(0.9),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),

                          const SizedBox(height: 24),

                          // الوصف التفصيلي
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: MyColors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: MyColors.white.withOpacity(0.25),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'مشروع تخرج متميز',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: MyColors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'صُمم التطبيق خصيصًا ليخدم الأهداف الأكاديمية والبحثية، ويعزز الرعاية الصحية الرقمية بابتكار حلول تكنولوجية عملية تُحسن من جودة حياة المريض.',
                                        textAlign: TextAlign.justify,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: MyColors.white.withOpacity(
                                                0.85,
                                              ),
                                              height: 1.6,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // شارة الكلية
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: MyColors.white.withOpacity(0.4),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.school_rounded,
                                      color: MyColors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'كلية الصيدلة',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: MyColors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // زر التالي
                NextButton(pageController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
