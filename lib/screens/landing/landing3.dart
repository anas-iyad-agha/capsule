import 'package:capsule/screens/landing/components/nextButton.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';

class Landing3 extends StatelessWidget {
  final PageController pageController;
  const Landing3(this.pageController, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(200, 27, 53, 88),
            Color.fromARGB(220, 63, 140, 255),
          ],
        ),
      ),
      child: Stack(
        children: [
          // خلفية الشعار الشفافة
          Positioned(
            top: screenSize.height * 0.1,
            left: -50,
            child: Opacity(
              opacity: 0.06,
              child: Image.asset(
                'assets/images/IUST-logo.png',
                width: screenSize.width * 1.3,
                height: screenSize.height * 0.7,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // دوائر زخرفية
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.primaryBlue.withOpacity(0.08),
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.accentTeal.withOpacity(0.05),
              ),
            ),
          ),

          // المحتوى الرئيسي
          Padding(
            padding: EdgeInsets.fromLTRB(16, screenSize.height * 0.1, 16, 24),
            child: Column(
              children: [
                // المحتوى المركزي
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // الشعار داخل إطار دائري
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  MyColors.white.withOpacity(0.25),
                                  MyColors.white.withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(
                                color: MyColors.white.withOpacity(0.4),
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: MyColors.primaryBlue.withOpacity(0.3),
                                  blurRadius: 25,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image.asset(
                                'assets/images/IUST-MEDI-FIle-LOGO.png',
                                fit: BoxFit.contain,
                                // color: MyColors.white.withOpacity(0.9),
                                // colorBlendMode: BlendMode.lighten,
                              ),
                            ),
                          ),

                          const SizedBox(height: 48),

                          // العنوان الرئيسي
                          Text(
                            'تطبيق الملف السريري',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  color: MyColors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'وتنبيهات مواعيد الدواء',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: MyColors.white.withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),

                          const SizedBox(height: 32),

                          // بطاقة الإشراف
                          Container(
                            padding: const EdgeInsets.all(20),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.supervisor_account_rounded,
                                      color: MyColors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'تحت إشراف',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: MyColors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'أ.د. محمد المنتصر',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: MyColors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'كلية الصيدلة',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: MyColors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // رسالة الشكر
                          Text(
                            'شكراً لدعمكم وإشرافكم على هذا المشروع',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: MyColors.white.withOpacity(0.85),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.6,
                                ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            height: 2,
                            width: 60,
                            decoration: BoxDecoration(
                              color: MyColors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // زر البدء
                NextButton(pageController, isLastPage: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
