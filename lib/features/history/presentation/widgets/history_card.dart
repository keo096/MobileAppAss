import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/data/models/history_model.dart';
import 'package:smart_quiz/data/models/quiz_model.dart';

/// Individual history card showing quiz details
class HistoryCard extends StatelessWidget {
  final dynamic history; // Can be QuizHistory or Quiz
  final VoidCallback? onTap;
  final bool isAdmin;

  const HistoryCard({
    super.key,
    required this.history,
    this.onTap,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final isQuiz = history is Quiz;
    final title = isQuiz
        ? (history as Quiz).title
        : (history as QuizHistory).quizTitle;
    final category = isQuiz
        ? (history as Quiz).category
        : (history as QuizHistory).category;
    final score = isQuiz ? 0.0 : (history as QuizHistory).score;
    final status = isQuiz ? 'completed' : (history as QuizHistory).status;
    final isCompleted = status == 'completed';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                _buildAvatar(title),

                const SizedBox(width: 14),

                // Quiz Info
                Expanded(child: _buildQuizInfo(title, category)),

                // Status Button
                _buildStatusButton(isCompleted),
              ],
            ),

            const SizedBox(height: 14),

            // Details Row
            _buildDetailsRow(isQuiz),

            const SizedBox(height: 14),

            // Progress Bar
            if (!isQuiz) _buildProgressBar(score),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String title) {
    final avatarColor = _getAvatarColor(title);

    return CircleAvatar(
      radius: 28,
      backgroundColor: avatarColor,
      child: Text(
        title.isNotEmpty ? title[0].toUpperCase() : '?',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuizInfo(String title, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          category,
          style: AppTheme.caption.copyWith(
            color: AppColors.textGrey600,
            fontSize: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatusButton(bool isCompleted) {
    // Admin sees "View" button, User sees "Done" or "Resume"
    final buttonText = isAdmin ? 'View' : (isCompleted ? 'Done' : 'Resume');

    final buttonColor = isAdmin
        ? AppColors.primaryPurple
        : (isCompleted ? Colors.green : Colors.orange);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: buttonColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: buttonColor, width: 1.5),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: buttonColor,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildDetailsRow(bool isQuiz) {
    if (isQuiz) {
      final quiz = history as Quiz;
      return Row(
        children: [
          const Icon(
            Icons.help_outline,
            size: 16,
            color: AppColors.primaryPurple,
          ),
          const SizedBox(width: 5),
          Text(
            '${quiz.totalQuestions} Questions',
            style: AppTheme.caption.copyWith(
              color: AppColors.textGrey600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 18),
          const Icon(
            Icons.timer_outlined,
            size: 16,
            color: AppColors.primaryPurple,
          ),
          const SizedBox(width: 5),
          Text(
            '${quiz.timeLimit ~/ 60} min',
            style: AppTheme.caption.copyWith(
              color: AppColors.textGrey600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 18),
          const Icon(
            Icons.trending_up,
            size: 16,
            color: AppColors.primaryPurple,
          ),
          const SizedBox(width: 5),
          Text(
            quiz.difficulty.toUpperCase(),
            style: AppTheme.caption.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: _getDifficultyColor(quiz.difficulty),
            ),
          ),
        ],
      );
    }

    final quizHistory = history as QuizHistory;
    return Row(
      children: [
        const Icon(Icons.access_time, size: 16, color: AppColors.primaryPurple),
        const SizedBox(width: 5),
        Text(
          '${quizHistory.timeTaken ~/ 60} min',
          style: AppTheme.caption.copyWith(
            color: AppColors.textGrey600,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 18),
        Text(
          '${quizHistory.score.toInt()}%',
          style: AppTheme.caption.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 18),
        Text(
          _formatDate(quizHistory.completedAt),
          style: AppTheme.caption.copyWith(
            color: AppColors.textGrey600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double score) {
    final scoreColor = _getScoreColor(score);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LinearProgressIndicator(
        value: score / 100,
        minHeight: 7,
        backgroundColor: AppColors.backgroundGrey,
        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return AppColors.primaryPurple;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getAvatarColor(String title) {
    if (title.isEmpty) return Colors.grey;
    final firstLetter = title[0].toUpperCase();
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.teal,
      Colors.orange,
    ];
    return colors[firstLetter.codeUnitAt(0) % colors.length];
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]}, ${date.year}';
    }
  }
}
