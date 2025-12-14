import 'package:capsule/screens/main-screen/main-screen.dart';
import 'package:flutter/material.dart';

import 'package:capsule/theme.dart';

class NextButton extends StatelessWidget {
  final PageController pageController;
  final bool isLastPage;

  const NextButton(this.pageController, {this.isLastPage = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyColors.white.withOpacity(0.25),
                MyColors.white.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColors.white.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.white.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: MyColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              if (!isLastPage && pageController.hasClients) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  MainScreen.route,
                  (route) => false,
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLastPage ? 'البدء' : 'التالي',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  isLastPage
                      ? Icons.check_circle_rounded
                      : Icons.arrow_back_rounded,
                  color: MyColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
