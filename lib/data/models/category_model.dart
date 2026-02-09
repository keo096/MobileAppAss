import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final String subtitle;
  final double progress;
  final dynamic icon; // Can be IconData or String (emoji)
  final Color color;

  Category({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    // Parse color
    Color parsedColor = const Color(0xFF4CAF50);
    final colorData =
        json['color'] ??
        json['colorValue'] ??
        json['color_value'] ??
        json['color_code'];
    if (colorData is int) {
      parsedColor = Color(colorData);
    } else if (colorData is String && colorData.startsWith('#')) {
      parsedColor = Color(
        int.parse(colorData.substring(1).padLeft(8, 'FF'), radix: 16),
      );
    }

    // Parse icon
    dynamic parsedIcon = Icons.menu_book;
    final iconData = json['icon'] ?? json['iconCode'] ?? json['icon_code'];
    if (iconData is int) {
      parsedIcon = IconData(iconData, fontFamily: 'MaterialIcons');
    } else if (iconData is String) {
      parsedIcon = iconData; // Likely an emoji or image path
    }

    return Category(
      id: (json['id'] ?? '').toString(),
      title: (json['name'] ?? json['title'] ?? '').toString(),
      subtitle: (json['description'] ?? json['subtitle'] ?? '').toString(),
      progress: (json['progress'] ?? 0.0).toDouble(),
      icon: parsedIcon,
      color: parsedColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'progress': progress,
      'iconCode': icon is IconData ? (icon as IconData).codePoint : null,
      'iconString': icon is String ? icon as String : null,
      'colorValue': color.value,
    };
  }
}
