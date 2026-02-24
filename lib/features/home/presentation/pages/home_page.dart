import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/constants/app_assets.dart';
import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/core/utils/formatters.dart';
import 'package:smart_quiz/core/widgets/bottom_nav_bar.dart';
import 'package:smart_quiz/features/category/presentation/providers/category_provider.dart';
import 'package:smart_quiz/features/history/presentation/pages/history_page.dart';
import 'package:smart_quiz/features/home/presentation/widgets/quiz_card.dart';
import 'package:smart_quiz/features/category/presentation/pages/category_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/create_quiz_page.dart';
import 'package:smart_quiz/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:smart_quiz/features/result/presentation/pages/result_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/category_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:smart_quiz/features/category/presentation/providers/category_provider.dart';
import 'package:smart_quiz/features/notification/presentation/pages/notification_page.dart';
import 'package:smart_quiz/features/notification/presentation/providers/notification_provider.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String? _username;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await ApiConfig.auth.getCurrentUser();
    final isAdmin = await ApiConfig.auth.isAdmin();
    if (mounted) {
      setState(() {
        _username = user?.username;
        _isAdmin = isAdmin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _username ?? "User";
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppTheme.homeGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(AppAssets.profileImage),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Formatters.formatGreeting(username),
                              style: AppTheme.greetingText,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              AppStrings.readyToLearn,
                              style: AppTheme.subtitleText,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) =>
                                    NotificationProvider()..loadNotification(),
                                child: const NotificationPage(),
                              ),
                            ),
                          );
                        },
                        child: _buildHeaderIcon(
                          Icons.notifications_none,
                          hasBadge: true,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // _buildHeaderIcon(Icons.settings_sharp),
                    ],
                  ),
                ),
              ),
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          // height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              icon: Icon(Icons.search, color: Colors.white70),
                              hintText: AppStrings.searchHint,
                              hintStyle: AppTheme.searchHintText,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            29,
                            255,
                            255,
                            255,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            width: 1,
                          ),
                        ),

                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories
              _buildSectionTitle(AppStrings.selectCategory),
              SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    final isSmallScreen = screenHeight < 600;
                    final categoryHeight = isSmallScreen ? 100.0 : 120.0;

                    return ChangeNotifierProvider(
                      create: (_) => CategoryProvider()..loadCategories(),
                      child: Consumer<CategoryProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return SizedBox(
                              height: categoryHeight,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (provider.categories.isEmpty) {
                            return SizedBox(
                              height: categoryHeight,
                              child: const Center(child: Text('No categories')),
                            );
                          }

                          return SizedBox(
                            height: categoryHeight,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              itemCount: provider.categories.length,
                              itemBuilder: (context, index) {
                                final category = provider.categories[index];
                                return _buildCategoryItem(
                                  category.id,
                                  category.title,
                                  category.icon,
                                  category.color,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              // Action Buttons Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Join Quiz (user) / Create New Quiz (admin)
                      Expanded(
                        child: _buildActionButton(
                          height: 140,
                          icon: _isAdmin ? Icons.add_circle_outline : Icons.add,
                          label: _isAdmin ? 'Create Quiz' : 'Join Quiz',
                          color: const Color(0xFF7C4DFF),
                          onTap: () {
                            if (_isAdmin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateQuizPage(
                                    categoryTitle: 'General',
                                  ),
                                ),
                              );
                            } else {
                              _showJoinQuizDialog();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Leaderboard
                      Expanded(
                        child: _buildActionButton(
                          height: 140,
                          icon: Icons.bar_chart,
                          label: 'Leaderboard',
                          color: const Color(0xFF00C853),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LeaderboardPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Achievements
                      Expanded(
                        child: _buildActionButton(
                          height: 140,
                          icon: Icons.emoji_events_outlined,
                          label: 'Achievements',
                          color: const Color(0xFFFF6D00),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const HistoryPage(userId: 'user_001'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              // Bottom Section - Continue Learning (User) / My Quizzes (Admin)
              if (!_isAdmin) _buildContinueLearningSection(),
              if (_isAdmin) _buildAdminQuizSection(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  // --- Helper Widgets ---

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    double height = 100,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinQuizDialog() {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Join a Quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: codeController,
          decoration: InputDecoration(
            hintText: 'Enter quiz code',
            prefixIcon: const Icon(Icons.vpn_key_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final code = codeController.text.trim();
              Navigator.pop(ctx);
              if (code.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Joining quiz with code: $code')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C4DFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Join', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color.fromARGB(190, 0, 0, 0),
            size: 27,
          ),
        ),
        if (hasBadge)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 20,
              height: 20,
              padding: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  "5",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTheme.categoryTitle),
            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    String id,
    String title,
    dynamic icon,
    Color color,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isVerySmallScreen = screenWidth < 360;

        final itemWidth = isVerySmallScreen ? 65.0 : 74.0;
        final iconSize = isVerySmallScreen ? 28.0 : 34.0;
        final containerSize = isVerySmallScreen ? 60.0 : 70.0;
        final textHeight = isVerySmallScreen ? 28.0 : 32.0;

        Widget iconWidget;
        if (icon is IconData) {
          iconWidget = Icon(icon, color: Colors.white, size: iconSize);
        } else if (icon is String) {
          // If it's a URL, show network image; otherwise treat as emoji/text
          if (icon.startsWith('http') || icon.startsWith('https')) {
            iconWidget = ClipOval(
              child: Image.network(
                icon,
                width: containerSize - 12,
                height: containerSize - 12,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(icon, style: TextStyle(fontSize: iconSize - 6)),
                ),
              ),
            );
          } else {
            iconWidget = Center(
              child: Text(
                icon,
                style: TextStyle(fontSize: iconSize - 6, color: Colors.white),
              ),
            );
          }
        } else {
          iconWidget = Icon(
            Icons.category,
            color: Colors.white,
            size: iconSize,
          );
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CategoryDetailPage(categoryTitle: title, categoryId: id),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            width: itemWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔵 Icon Circle
                Container(
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: iconWidget,
                ),

                const SizedBox(height: 4),

                // 📝 Title (FIXED HEIGHT → prevents overflow)
                SizedBox(
                  height: textHeight,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontSize: isVerySmallScreen ? 10 : 12,
                      height: 1.2, // 🔥 control line spacing
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueLearningSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF673AB7), // Deep purple like in screenshot
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Continue Quiz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_up, color: Colors.white),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 150, // Fixed height for scrolling
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 243, 243, 243),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildContinueCard(
                      title: 'Preposition',
                      subtitle: 'time, place, movement',
                      letter: 'P',
                      color: Colors.green,
                      progress: 0.75,
                      time: '12 min',
                      percent: '75%',
                      date: '24 Jan, 2026',
                    ),
                    const SizedBox(height: 16),
                    _buildContinueCard(
                      title: 'Passive Voice',
                      subtitle: 'present, past',
                      letter: 'P',
                      color: Colors.blue,
                      progress: 0.5,
                      time: '12 min',
                      percent: '50%',
                      date: '24 Jan, 2026',
                    ),
                    const SizedBox(height: 16),
                    _buildContinueCard(
                      title: 'Passive Voice',
                      subtitle: 'present, past',
                      letter: 'P',
                      color: Colors.blue,
                      progress: 0.5,
                      time: '12 min',
                      percent: '50%',
                      date: '24 Jan, 2026',
                    ),
                    const SizedBox(height: 16),
                    _buildContinueCard(
                      title: 'Passive Voice',
                      subtitle: 'present, past',
                      letter: 'P',
                      color: Colors.blue,
                      progress: 0.5,
                      time: '12 min',
                      percent: '50%',
                      date: '24 Jan, 2026',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminQuizSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              // color: Color.fromARGB(255, 247, 247, 247),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF673AB7), // Different color for admin
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Created Quizzes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Icon(Icons.keyboard_arrow_up, color: Colors.white),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 150, // Fixed height for scrolling
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 243, 243, 243),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildAdminQuizCard(
                      title: 'Mathematics Advanced',
                      participants: 45,
                      avgScore: '82%',
                      date: '22 Jan, 2026',
                    ),
                    const SizedBox(height: 16),
                    _buildAdminQuizCard(
                      title: 'Science Quiz',
                      participants: 12,
                      avgScore: '65%',
                      date: '20 Jan, 2026',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueCard({
    required String title,
    required String subtitle,
    required String letter,
    required Color color,
    required double progress,
    required String time,
    required String percent,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color,
                child: Text(
                  letter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultPage(
                        quizTitle: title,
                        totalQuestions: 10,
                        correctAnswers: 8,
                        timeTaken: 300,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFFC107)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Resume',
                  style: TextStyle(color: Color(0xFFFFC107)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.purple),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              const Text('|', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 12),
              Text(
                percent,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              const Text('|', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 12),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminQuizCard({
    required String title,
    required int participants,
    required String avgScore,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFF673AB7),
                child: Icon(Icons.quiz, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Created on $date',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultPage(
                        quizTitle: title,
                        totalQuestions: 10,
                        correctAnswers: 8,
                        timeTaken: 300,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'View Results',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Participants', participants.toString()),
              _buildStat('Avg. Score', avgScore),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF673AB7),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }
}
