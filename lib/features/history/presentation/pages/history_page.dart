import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/history_model.dart';
import 'package:smart_quiz/data/models/quiz_model.dart';
import 'package:smart_quiz/core/widgets/bottom_nav_bar.dart';
import 'package:smart_quiz/features/history/presentation/widgets/history_header.dart';
import 'package:smart_quiz/features/history/presentation/widgets/history_tab_bar.dart';
import 'package:smart_quiz/features/history/presentation/widgets/history_statistics_card.dart';
import 'package:smart_quiz/features/history/presentation/widgets/history_card.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/quiz_review_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/quiz_resume_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/admin_quiz_detail_page.dart';

/// History page showing quiz history with tabs and statistics
class HistoryPage extends StatefulWidget {
  final String userId;
  const HistoryPage({super.key, required this.userId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _filteredHistory = []; // Can hold QuizHistory or Quiz
  Map<String, dynamic> _statistics = {};
  bool _isLoading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _checkRoleAndLoadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Check user role and load appropriate data
  Future<void> _checkRoleAndLoadData() async {
    if (!mounted) return;

    try {
      final isAdmin = await ApiConfig.auth.isAdmin();

      if (mounted) {
        setState(() {
          _isAdmin = isAdmin;
        });
        await _loadData();
      }
    } catch (e) {
      debugPrint('Error checking role: $e');
    }
  }

  /// Load quiz history data
  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isAdmin) {
        _filteredHistory = await ApiConfig.history.fetchHistory(widget.userId);
      } else {
        await _filterHistory(); // Load data based on current tab
      }
      _statistics = await ApiConfig.history.fetchHistoryStatistics();
    } catch (e) {
      debugPrint('Error loading history: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Handle tab changes
  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _filterHistory();
    }
  }

  /// Filter history based on selected tab
  Future<void> _filterHistory() async {
    if (!mounted || _isAdmin) return;

    try {
      List<QuizHistory> history = [];

      switch (_tabController.index) {
        case 0: // All
          history = await ApiConfig.history.fetchUserHistory(widget.userId);
          break;
        case 1: // Completed
          history = await ApiConfig.history.fetchHistoryByStatus(
            'completed',
            widget.userId,
          );
          break;
        case 2: // In Progress
          history = await ApiConfig.history.fetchHistoryByStatus(
            'in_progress',
            widget.userId,
          );
          break;
        case 3: // Saved
          history = await ApiConfig.history.fetchHistoryByStatus(
            'saved',
            widget.userId,
          );
          break;
      }

      if (mounted) {
        setState(() {
          _filteredHistory = history;
        });
      }
    } catch (e) {
      debugPrint('Error filtering history: $e');
    }
  }

  /// Handle filter button tap
  void _onFilterTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filter functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Handle history card tap - Navigate based on role
  void _onHistoryCardTap(dynamic item) {
    if (_isAdmin && item is Quiz) {
      // Admin: Navigate to Quiz Detail Page (shows questions + participants)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AdminQuizDetailPage(quizId: item.id, quizTitle: item.title),
        ),
      );
    } else if (item is QuizHistory) {
      // User: Navigate to Review or Resume page based on status
      if (item.status == 'completed') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizReviewPage(history: item),
          ),
        );
      } else if (item.status == 'in_progress') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResumePage(history: item),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.quizTitle} - Status: ${item.status}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryPurple,
              AppColors.primaryPurple.withOpacity(0.85),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              HistoryHeader(
                onFilterTap: _onFilterTap,
                title: _isAdmin ? 'Created Quizzes' : 'Quiz History',
              ),

              // Tab Bar - Only show for users
              if (!_isAdmin) HistoryTabBar(controller: _tabController),

              // Admin Info Banner
              if (_isAdmin)
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tap any quiz to view questions and participants',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Content Area
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundLightGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryPurple,
                          ),
                        )
                      : _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildContent() {
    if (_isAdmin) {
      // Admin: Show list of created quizzes
      return _buildQuizList();
    } else {
      // User: Show tabbed content with statistics
      return Column(
        children: [
          HistoryStatisticsCard(
            totalQuizzes: _statistics['totalQuizzes'] ?? 0,
            averageScore: (_statistics['averageScore'] ?? 0.0).toDouble(),
            totalTimeInSeconds: _statistics['totalTime'] ?? 0,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQuizList(), // All
                _buildQuizList(), // Completed
                _buildQuizList(), // In Progress
                _buildQuizList(), // Saved
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildQuizList() {
    if (_filteredHistory.isEmpty) {
      String message;
      if (_isAdmin) {
        message = 'No quizzes created yet';
      } else {
        switch (_tabController.index) {
          case 0:
            message = 'No quiz history yet';
            break;
          case 1:
            message = 'No completed quizzes yet';
            break;
          case 2:
            message = 'No quizzes in progress yet';
            break;
          case 3:
            message = 'No saved quizzes yet';
            break;
          default:
            message = 'No history found';
            break;
        }
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isAdmin ? Icons.quiz_outlined : Icons.history,
              size: 80,
              color: AppColors.textGrey600.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: AppColors.textGrey600,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isAdmin
                  ? 'Create your first quiz to see it here'
                  : 'Start taking quizzes to build your history',
              style: TextStyle(
                color: AppColors.textGrey600.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredHistory.length,
      itemBuilder: (context, index) {
        return HistoryCard(
          history: _filteredHistory[index],
          onTap: () => _onHistoryCardTap(_filteredHistory[index]),
          isAdmin: _isAdmin,
        );
      },
    );
  }
}
