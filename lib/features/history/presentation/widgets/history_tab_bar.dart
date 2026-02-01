import 'package:flutter/material.dart';

/// Custom tab bar for history page
class HistoryTabBar extends StatelessWidget {
  final TabController controller;

  const HistoryTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TabBar(
        controller: controller,
        indicatorColor: Colors.white,
        indicatorWeight: 3.5,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Completed'),
          Tab(text: 'In Progress'),
          Tab(text: 'Saved'),
        ],
      ),
    );
  }
}
