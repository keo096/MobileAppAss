import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/constants/app_assets.dart';
import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/core/utils/formatters.dart';
import 'package:smart_quiz/core/widgets/bottom_nav_bar.dart';
import 'package:smart_quiz/features/home/presentation/widgets/quiz_card.dart';
import 'package:smart_quiz/features/category/presentation/pages/category_page.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await ApiConfig.auth.getCurrentUser();
    if (mounted) {
      setState(() {
        _username = user?.username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _username ?? "User";
    return Scaffold(
      body: Container(
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
                      _buildHeaderIcon(Icons.settings_sharp),
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

                    return SizedBox(
                      height: categoryHeight,
                      child: ListView(
                        scrollDirection: Axis.horizontal, // ✅ left-right scroll
                        physics:
                            const BouncingScrollPhysics(), // smooth iOS feel
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        children: [
                          _buildCategoryItem(
                            "English",
                            Icons.menu_book_outlined,
                            Colors.indigo,
                          ),
                          _buildCategoryItem(
                            "Math",
                            Icons.calculate,
                            Colors.blue,
                          ),
                          _buildCategoryItem(
                            "Chemistry",
                            Icons.biotech,
                            Colors.teal,
                          ),
                          _buildCategoryItem(
                            "History",
                            Icons.assignment,
                            Colors.brown,
                          ),
                          _buildCategoryItem(
                            "General-knowlege",
                            Icons.psychology,
                            Colors.deepPurple,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Daily Quiz Card
              // 🔥 Daily Quiz Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenHeight = MediaQuery.of(context).size.height;
                      final screenWidth = MediaQuery.of(context).size.width;
                      final isSmallScreen =
                          screenWidth < 360 || screenHeight < 600;
                      final carouselHeight = isSmallScreen
                          ? 116.0
                          : 146.0; // Match QuizCard height + small padding

                      return CarouselSlider(
                        options: CarouselOptions(
                          height: carouselHeight,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          autoPlayInterval: const Duration(seconds: 4),
                        ),
                        items: [
                          QuizCard(
                            title: AppStrings.dailyQuizChallenge,
                            subtitle: "15 Questions • 7-10mins",
                            imagePath: AppAssets.dailyQuizImage,
                            buttonText: AppStrings.startNow,
                          ),
                          QuizCard(
                            title: AppStrings.learningGoals,
                            subtitle:
                                "Choose how many quizzes you want to finish each week",
                            imagePath: AppAssets.goalsImage,
                            buttonText: AppStrings.setGoal,
                          ),
                          QuizCard(
                            title: AppStrings.completeWithFriends,
                            subtitle:
                                "See how your rank compares on the leaderboard",
                            imagePath: AppAssets.progressImage,
                            buttonText: AppStrings.viewLeaderboard,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // ✅ Categories UNDER Daily Quiz
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  constraints: BoxConstraints(
                    maxHeight:
                        MediaQuery.of(context).size.height *
                        0.35, // Further reduced
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLightGrey,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    // Add clipping to prevent overflow
                    borderRadius: BorderRadius.circular(24),
                    child: ChangeNotifierProvider(
                      create: (context) => CategoryProvider()..loadCategories(),
                      child: const CategoryPage(isScrollable: false),
                    ),
                  ),
                ),
              ),

              // Add bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
      // Floating Action Button
      // floatingActionButton: Container(
      //   height: 70,
      //   width: 70,
      //   child: FloatingActionButton(
      //     onPressed: () {},
      //     backgroundColor: const Color(0xFF6A2CA0),
      //     // child: const Icon(Icons.add, size: 40, color: Colors.white),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  // --- Helper Widgets ---

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

  Widget _buildCategoryItem(String title, IconData icon, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isVerySmallScreen = screenWidth < 360;

        final itemWidth = isVerySmallScreen ? 65.0 : 74.0;
        final iconSize = isVerySmallScreen ? 28.0 : 34.0;
        final containerSize = isVerySmallScreen ? 60.0 : 70.0;
        final textHeight = isVerySmallScreen ? 28.0 : 32.0;

        return Container(
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
                child: Icon(icon, color: Colors.white, size: iconSize),
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
        );
      },
    );
  }
}
