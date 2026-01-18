import 'package:flutter/material.dart' show IconData, Color;

class Category {
  final String title;
  final String subtitle;
  final double progress;
  final IconData icon;
  final Color color;

  Category({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    required this.color,
  });
}
