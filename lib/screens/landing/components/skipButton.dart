import 'package:Capsule/screens/main-screen/main-screen.dart';
import 'package:Capsule/theme.dart';
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

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
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainScreen.route,
              (route) => false,
            );
          },
          child: const Text('اختصار'),
        ),
      ],
    );
  }
}
