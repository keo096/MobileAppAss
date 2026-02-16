import 'package:flutter/material.dart';
import 'package:smart_quiz/data/models/leaderboard_model.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool highlight;

  const LeaderboardTile({super.key, required this.entry, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final name = entry.user.name;
    final points = entry.stats.points;
    final rank = entry.rank;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primaryPurple.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight ? AppColors.primaryPurple : Colors.grey.shade200,
          width: highlight ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            rank.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 15),
          CircleAvatar(
            backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primaryPurple,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Accuracy: ${entry.stats.accuracy}%',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$points XP',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryPurple,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
