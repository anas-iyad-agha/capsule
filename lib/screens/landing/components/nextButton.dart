import 'package:Capsule/screens/main-screen/main-screen.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class NextButton extends StatelessWidget {
  final PageController pageController;
  final bool isLastPage;
  const NextButton(this.pageController, {this.isLastPage = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: MyColors.lightWhite,
            textStyle: const TextStyle(
              fontSize: 16,
              letterSpacing: 2,
              fontWeight: FontWeight.w400,
            ),
          ),
          onPressed: () {
            if (!isLastPage && pageController.hasClients) {
              pageController.nextPage(
                duration: Duration(milliseconds: 300),
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
          child: Text(isLastPage ? 'البدء' : 'التالي'),
        ),
      ],
    );
  }
}
