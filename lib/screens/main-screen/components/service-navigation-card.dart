import 'package:flutter/material.dart';

class ServiceNavigationCard extends StatelessWidget {
  final String route;
  final IconData icon;
  final String title;
  final String description;
  final double? width;
  const ServiceNavigationCard({
    required this.title,
    required this.route,
    required this.description,
    required this.icon,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.cyan),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
