import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/core/data/mock_data.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
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
  const HistoryPage({super.key});

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
  void _checkRoleAndLoadData() {
    setState(() {
      _isAdmin = MockData.isAdmin();
      _isLoading = true;
    });

    _loadData();
  }

  /// Load quiz history data
  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          if (_isAdmin) {
            // Admin: Load created quizzes
            _filteredHistory = MockData.getCreatedQuizzes();
          } else {
            // User: Load quiz history
            _filteredHistory = MockData.getQuizHistory();
          }
          _statistics = MockData.getHistoryStatistics();
          _isLoading = false;
        });
      }
    });
  }

  /// Handle tab changes
  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _filterHistory();
    }
  }

  /// Filter history based on selected tab
  void _filterHistory() {
    setState(() {
      if (_isAdmin) {
        // Admin: Show all created quizzes (no filtering by status)
        _filteredHistory = MockData.getCreatedQuizzes();
      } else {
        // User: Filter by status
        switch (_tabController.index) {
          case 0: // All
            _filteredHistory = MockData.getQuizHistory();
            break;
          case 1: // Completed
            _filteredHistory = MockData.getQuizHistoryByStatus('completed');
            break;
          case 2: // In Progress
            _filteredHistory = MockData.getQuizHistoryByStatus('in_progress');
            break;
          case 3: // Saved
            _filteredHistory = MockData.getQuizHistoryByStatus('saved');
            break;
        }
      }
    });
  }

  /// Handle filter button tap
  void _onFilterTap() {
    // TODO: Implement filter functionality
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
        // Navigate to Quiz Review Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizReviewPage(history: item),
          ),
        );
      } else if (item.status == 'in_progress') {
        // Navigate to Quiz Resume Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResumePage(history: item),
          ),
        );
      } else {
        // For saved quizzes or other statuses
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
              // Header - Different title based on role
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
      // Admin: Show simple list of created quizzes (no tabs, no statistics)
      return _buildQuizList();
    } else {
      // User: Show tabbed content with statistics
      return Column(
        children: [
          // Statistics Card
          HistoryStatisticsCard(
            totalQuizzes: _statistics['totalQuizzes'] ?? 0,
            averageScore: (_statistics['averageScore'] ?? 0.0).toDouble(),
            totalTimeInSeconds: _statistics['totalTime'] ?? 0,
          ),

          // Tab Content
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
          case 0: // All
            message = 'No quiz history yet';
            break;
          case 1: // Completed
            message = 'No completed quizzes yet';
            break;
          case 2: // In Progress
            message = 'No quizzes in progress yet';
            break;
          case 3: // Saved
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
