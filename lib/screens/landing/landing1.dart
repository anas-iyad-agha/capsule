import 'package:capsule/screens/landing/components/customImage.dart';
import 'package:capsule/screens/landing/components/nextButton.dart';
import 'package:capsule/screens/landing/components/skipButton.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';

class Landing1 extends StatelessWidget {
  final PageController pageController;
  const Landing1(this.pageController, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height - MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(200, 63, 140, 255),
            Color.fromARGB(220, 27, 53, 88),
          ],
        ),
      ),
      child: Stack(
        children: [
          // خلفية الصورة الشفافة
          Positioned(
            top: -50,
            right: -50,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/landing1.png',
                width: screenSize.width * 1.2,
                height: screenSize.height * 0.8,
                fit: BoxFit.cover,
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
                          // الأيقونة الرئيسية
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: MyColors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: MyColors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.local_pharmacy_rounded,
                              color: MyColors.white,
                              size: 80,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // العنوان الرئيسي
                          Text(
                            'تطبيق كبسولة',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  color: MyColors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          const SizedBox(height: 20),

                          // الوصف
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                Text(
                                  'إدارة صحتك بذكاء',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: MyColors.white.withOpacity(0.9),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'نظام متكامل لإدارة ملفك الصحي وتتبع مواعيد أدويتك بدقة. احفظ بيانات صحتك الشاملة وتلقَّ تنبيهات ذكية لتناول الأدوية في الوقت المحدد.',
                                  textAlign: TextAlign.justify,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: MyColors.white.withOpacity(0.85),
                                        fontSize: 15,
                                        height: 1.6,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // النقاط المميزة
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildFeature(
                                icon: Icons.folder_open_rounded,
                                label: 'ملف سريري',
                                context: context,
                              ),
                              _buildFeature(
                                icon: Icons.notifications_active_rounded,
                                label: 'تنبيهات ذكية',
                                context: context,
                              ),
                              _buildFeature(
                                icon: Icons.security_rounded,
                                label: 'آمن وموثوق',
                                context: context,
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

  Widget _buildFeature({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MyColors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: MyColors.white.withOpacity(0.3)),
          ),
          child: Icon(icon, color: MyColors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: MyColors.white.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
