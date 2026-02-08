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
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      icon: IconData(
        ((json['iconCode'] ?? json['icon_code'] ?? 0xe3af) as num).toInt(),
        fontFamily: 'MaterialIcons',
      ),
      color: Color(
        ((json['colorValue'] ??
                    json['color_value'] ??
                    json['color_code'] ??
                    0xFF4CAF50)
                as num)
            .toInt(),
      ),
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
