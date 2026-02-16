import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:smart_quiz/data/models/leaderboard_model.dart';

class PodiumItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final double avatarSize;

  const PodiumItem({super.key, required this.entry, required this.rank, this.avatarSize = 70});

  @override
  Widget build(BuildContext context) {
    final displayName = entry.user.name;
    final points = entry.stats.points;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: avatarSize + 10,
              height: avatarSize + 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: rank == 1
                      ? Colors.amber
                      : (rank == 2 ? Colors.grey.shade300 : Colors.brown.shade300),
                  width: 4,
                ),
              ),
            ),
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: Colors.white24,
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: rank == 1
                      ? Colors.amber
                      : (rank == 2 ? Colors.grey.shade300 : Colors.brown.shade300),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  rank.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          displayName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$points XP',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
