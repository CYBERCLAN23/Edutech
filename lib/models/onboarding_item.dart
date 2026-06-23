import 'package:flutter/material.dart';

class OnboardingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const OnboardingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
