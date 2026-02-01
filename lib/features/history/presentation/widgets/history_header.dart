import 'package:flutter/material.dart';

/// Header widget for history page
class HistoryHeader extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final String title;

  const HistoryHeader({
    super.key,
    this.onFilterTap,
    this.title = 'Quiz History',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),
    );
  }
}
