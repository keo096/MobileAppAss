import 'package:flutter/material.dart';
import 'package:smart_quiz/core/widgets/bottom_nav_bar.dart';
import 'package:smart_quiz/core/widgets/empty_state.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/features/history/presentation/providers/history_provider.dart';

/// History page showing user's quiz history
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryProvider _provider = HistoryProvider();

  @override
  void initState() {
    super.initState();
    // Listen to provider changes - UI will update automatically
    _provider.addListener(_onProviderChange);
    // Load history
    _provider.loadHistory();
  }

  // This method is called whenever provider state changes
  void _onProviderChange() {
    if (mounted) {
      setState(() {}); // Rebuild UI when provider state changes
    }
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    _provider.removeListener(_onProviderChange);
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use provider state - UI updates automatically when provider changes
    if (_provider.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            AppStrings.history,
            style: AppTheme.headingMedium,
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: const BottomNavBar(
          currentIndex: 1,
        ),
      );
    }

    if (_provider.errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            AppStrings.history,
            style: AppTheme.headingMedium,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                _provider.errorMessage!,
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _provider.loadHistory(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(
          currentIndex: 1,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppStrings.history,
          style: AppTheme.headingMedium,
        ),
        centerTitle: true,
      ),
      body: _provider.isEmpty
          ? EmptyState(
              type: EmptyStateType.noHistory,
              actionText: 'Start a Quiz',
              onAction: () {
                // TODO: Navigate to category/quiz selection
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _provider.history.length,
              itemBuilder: (context, index) {
                return _buildHistoryCard(_provider.history[index]);
              },
            ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 1,
      ),
    );
  }


  Widget _buildHistoryCard(QuizHistory history) {
    // Format date
    final dateStr = _formatDate(history.completedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.backgroundGrey,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Category Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryPurpleLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.quiz,
              color: AppColors.primaryPurple,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          // Quiz Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.quizTitle,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  history.category,
                  style: AppTheme.caption.copyWith(
                    color: AppColors.textGrey600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.textGrey600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateStr,
                      style: AppTheme.caption.copyWith(
                        color: AppColors.textGrey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${history.score.toInt()}%",
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textGrey600,
              ),
            ],
          ),
        ],
      ),
    );
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
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
