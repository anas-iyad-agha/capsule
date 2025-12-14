import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';

// ==================== TextSection (محسّنة) ====================
class TextSection extends StatelessWidget {
  final String title;
  final String paragraph;

  const TextSection(this.title, this.paragraph, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: MyColors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            paragraph,
            softWrap: true,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: MyColors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
              height: 1.7,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
