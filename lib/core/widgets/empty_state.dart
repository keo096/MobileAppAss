import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';

/// Reusable empty state widget for displaying no data or error states
class EmptyState extends StatelessWidget {
  /// Type of empty state
  final EmptyStateType type;

  /// Custom title (optional, will use default based on type if not provided)
  final String? title;

  /// Custom message (optional, will use default based on type if not provided)
  final String? message;

  /// Custom icon (optional, will use default based on type if not provided)
  final IconData? icon;

  /// Custom icon color (optional)
  final Color? iconColor;

  /// Action button text (optional, if null, no button will be shown)
  final String? actionText;

  /// Action button callback (optional)
  final VoidCallback? onAction;

  /// Custom widget to replace the default icon
  final Widget? customIcon;

  const EmptyState({
    super.key,
    this.type = EmptyStateType.empty,
    this.title,
    this.message,
    this.icon,
    this.iconColor,
    this.actionText,
    this.onAction,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            if (customIcon != null)
              customIcon!
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: (iconColor ?? config.iconColor)
                      .withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? config.icon,
                  size: 80,
                  color: iconColor ?? config.iconColor,
                ),
              ),
            const SizedBox(height: 24),
            // Title
            Text(
              title ?? config.title,
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.textBlack87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              message ?? config.message,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.textGrey600,
              ),
              textAlign: TextAlign.center,
            ),
            // Action Button
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(config.actionIcon),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.buttonColor,
                  foregroundColor: AppColors.textWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  EmptyStateConfig _getConfig() {
    switch (type) {
      case EmptyStateType.empty:
        return const EmptyStateConfig(
          icon: Icons.inbox_outlined,
          iconColor: AppColors.primaryPurple,
          title: 'No Data',
          message: 'There is no data to display at the moment.',
          actionIcon: Icons.refresh,
          buttonColor: AppColors.primaryPurple,
        );

      case EmptyStateType.noHistory:
        return const EmptyStateConfig(
          icon: Icons.history,
          iconColor: AppColors.primaryPurple,
          title: 'No Quiz History',
          message: 'Your completed quizzes will appear here',
          actionIcon: Icons.quiz,
          buttonColor: AppColors.primaryPurple,
        );
      case EmptyStateType.noNotification:
        return const EmptyStateConfig(
          icon: Icons.history,
          iconColor: AppColors.primaryPurple,
          title: 'No Notification',
          message: "You don’t have any notification",
          actionIcon: Icons.quiz,
          buttonColor: AppColors.primaryPurple,
        );

      case EmptyStateType.noResults:
        return const EmptyStateConfig(
          icon: Icons.search_off,
          iconColor: AppColors.primaryPurple,
          title: 'No Results Found',
          message: 'Try adjusting your search criteria',
          actionIcon: Icons.refresh,
          buttonColor: AppColors.primaryPurple,
        );

      case EmptyStateType.error:
        return const EmptyStateConfig(
          icon: Icons.error_outline,
          iconColor: AppColors.error,
          title: 'Something Went Wrong',
          message: 'An error occurred. Please try again later.',
          actionIcon: Icons.refresh,
          buttonColor: AppColors.error,
        );

      case EmptyStateType.networkError:
        return const EmptyStateConfig(
          icon: Icons.wifi_off,
          iconColor: AppColors.error,
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
          actionIcon: Icons.refresh,
          buttonColor: AppColors.error,
        );

      case EmptyStateType.serverError:
        return const EmptyStateConfig(
          icon: Icons.cloud_off,
          iconColor: AppColors.error,
          title: 'Server Error',
          message: 'Unable to connect to the server. Please try again later.',
          actionIcon: Icons.refresh,
          buttonColor: AppColors.error,
        );

      case EmptyStateType.notFound:
        return const EmptyStateConfig(
          icon: Icons.search_off,
          iconColor: AppColors.warning,
          title: 'Not Found',
          message: 'The requested content could not be found.',
          actionIcon: Icons.arrow_back,
          buttonColor: AppColors.warning,
        );

      case EmptyStateType.permissionDenied:
        return const EmptyStateConfig(
          icon: Icons.lock_outline,
          iconColor: AppColors.warning,
          title: 'Access Denied',
          message: 'You don\'t have permission to view this content.',
          actionIcon: Icons.arrow_back,
          buttonColor: AppColors.warning,
        );

      case EmptyStateType.loadingError:
        return const EmptyStateConfig(
          icon: Icons.hourglass_empty,
          iconColor: AppColors.error,
          title: 'Loading Failed',
          message: 'Failed to load data. Please try again.',
          actionIcon: Icons.refresh,
          buttonColor: AppColors.error,
        );
    }
  }
}

/// Types of empty states
enum EmptyStateType {
  /// Generic empty state
  empty,

  /// No quiz history
  noHistory,

  /// No search results
  noResults,

  // No Notification

  noNotification,

  /// Generic error
  error,

  /// Network connection error
  networkError,

  /// Server error
  serverError,

  /// Content not found
  notFound,

  /// Permission denied
  permissionDenied,

  /// Loading error
  loadingError,
}

/// Configuration for empty state appearance
class EmptyStateConfig {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final IconData actionIcon;
  final Color buttonColor;

  const EmptyStateConfig({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.actionIcon,
    required this.buttonColor,
  });
}

