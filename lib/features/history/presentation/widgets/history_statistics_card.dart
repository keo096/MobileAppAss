import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';

/// Statistics card showing total quizzes, average score, and time spent
class HistoryStatisticsCard extends StatelessWidget {
  final int totalQuizzes;
  final double averageScore;
  final int? totalTimeInSeconds;
  final int? totalParticipants;
  final bool isAdmin;

  const HistoryStatisticsCard({
    super.key,
    required this.totalQuizzes,
    required this.averageScore,
    this.totalTimeInSeconds,
    this.totalParticipants,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total Quizzes
          _buildStatColumn(
            icon: isAdmin ? Icons.assignment_outlined : Icons.grid_view_rounded,
            label: isAdmin ? 'Created' : 'Quizzes',
            value: '$totalQuizzes',
          ),

          // Average Score (Circular Progress)
          _buildAverageScore(),

          // Third Stat (Time or Participants)
          if (isAdmin)
            _buildStatColumn(
              icon: Icons.people_outline,
              label: 'Participants',
              value: '${totalParticipants ?? 0}',
              crossAxisAlignment: CrossAxisAlignment.end,
            )
          else
            _buildTimeSpent(),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required String label,
    required String value,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (crossAxisAlignment == CrossAxisAlignment.end) ...[
              Text(
                label,
                style: AppTheme.caption.copyWith(
                  color: AppColors.textGrey600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: AppColors.primaryPurple),
            ] else ...[
              Icon(icon, size: 16, color: AppColors.primaryPurple),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTheme.caption.copyWith(
                  color: AppColors.textGrey600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack87,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSpent() {
    final totalSeconds = totalTimeInSeconds ?? 0;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    return _buildStatColumn(
      icon: Icons.access_time,
      label: 'Time spent',
      value: '${hours}h ${minutes}m',
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }

  Widget _buildAverageScore() {
    Color scoreColor = averageScore >= 80
        ? Colors.green
        : averageScore >= 60
        ? Colors.orange
        : Colors.red;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: averageScore / 100,
                strokeWidth: 7,
                backgroundColor: AppColors.backgroundGrey,
                valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${averageScore.toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack87,
                  ),
                ),
                Text(
                  'Avg',
                  style: AppTheme.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.textGrey600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
