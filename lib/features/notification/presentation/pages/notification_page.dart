import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/features/notification/presentation/widgets/notification_widget.dart';
import 'package:smart_quiz/features/notification/presentation/providers/notification_provider.dart';
import 'package:smart_quiz/data/models/notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .loadNotification();
    });
  }

  String _getEmojiForType(NotificationType type) {
    switch (type) {
      case NotificationType.dailyQuiz:
        return '🔥';
      case NotificationType.leaderboard:
        return '🏆';
      case NotificationType.achievement:
        return '🏅';
      case NotificationType.reminder:
        return '📌';
      case NotificationType.badge:
        return '🎖️';
      default:
        return '🔔';
    }
  }

  Color _getBackgroundColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.leaderboard:
        return const Color(0xFFDDC4EE); // Light purple
      case NotificationType.achievement:
        return const Color(0xFFFDD835); // Light yellow
      case NotificationType.reminder:
        return const Color(0xFFFFCDD2); // Light red
      case NotificationType.badge:
        return const Color(0xFFC8E6C9); // Light green
      default:
        return const Color(0xFFFFE5CC); // Light orange (default)
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays == 1) {
      return '1d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Now';
    }
  }

  Map<String, List<AppNotification>> _groupNotifications(
      List<AppNotification> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    List<AppNotification> todayList = [];
    List<AppNotification> yesterdayList = [];
    List<AppNotification> olderList = [];

    for (var notification in notifications) {
      final date = notification.createdAt;
      final checkDate = DateTime(date.year, date.month, date.day);

      if (checkDate.isAtSameMomentAs(today)) {
        todayList.add(notification);
      } else if (checkDate.isAtSameMomentAs(yesterday)) {
        yesterdayList.add(notification);
      } else {
        olderList.add(notification);
      }
    }

    return {
      'Today': todayList,
      'Yesterday': yesterdayList,
      'Older': olderList,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: AppTheme.headingMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false)
                  .clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryPurple,
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.textBlack87,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Notifications',
                    style: AppTheme.headingSmall,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      provider.errorMessage ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textBlack87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadNotification(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: AppColors.textBlack87,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Notifications',
                    style: AppTheme.headingSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You\'re all caught up!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlack87,
                    ),
                  ),
                ],
              ),
            );
          }

          final grouped = _groupNotifications(provider.notification);

          return CustomScrollView(
            slivers: [
              if (grouped['Today']!.isNotEmpty) ...[
                _buildSectionHeader('Today'),
                _buildNotificationList(grouped['Today']!, provider),
              ],
              if (grouped['Yesterday']!.isNotEmpty) ...[
                _buildSectionHeader('Yesterday'),
                _buildNotificationList(grouped['Yesterday']!, provider),
              ],
              if (grouped['Older']!.isNotEmpty) ...[
                _buildSectionHeader('Older'),
                _buildNotificationList(grouped['Older']!, provider),
              ],
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(
            color: AppColors.textBlack87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    List<AppNotification> notifications,
    NotificationProvider provider,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final notification = notifications[index];
          final hasAction =
              notification.type == NotificationType.dailyQuiz &&
                  !notification.isRead;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: NotificationCard(
              title: notification.title,
              description: notification.subtitle,
              emoji: _getEmojiForType(notification.type),
              time: _getTimeAgo(notification.createdAt),
              hasAction: hasAction,
              actionLabel: 'Start Now',
              backgroundColor: _getBackgroundColorForType(notification.type),
              onActionPressed: () {
                provider.markAsRead(notification.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${notification.title} clicked'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          );
        },
        childCount: notifications.length,
      ),
    );
  }
}
