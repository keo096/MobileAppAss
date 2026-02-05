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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      subtitle: json['subtitle'],
      progress: (json['progress'] ?? 0.0).toDouble(),
      icon: IconData(json['iconCode'] ?? 0xe3af, fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue'] ?? 0xFF4CAF50),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'progress': progress,
      'iconCode': icon.codePoint,
      'colorValue': color.value,
    };
  }
}
