import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/constants/app_assets.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/core/utils/formatters.dart';
import 'package:smart_quiz/core/widgets/bottom_nav_bar.dart';
import 'package:smart_quiz/features/home/presentation/widgets/quiz_card.dart';
import 'package:smart_quiz/features/category/presentation/pages/category_page.dart';

class UserHomePage extends StatelessWidget {
  final String username;
  const UserHomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.homeGradient,
        ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Formatters.formatGreeting(username),
                            style: AppTheme.greetingText,
                          ),
                          Text(
                            AppStrings.readyToLearn,
                            style: AppTheme.subtitleText,
                          ),
                        ],
                      ),
                      const Spacer(),
                      _buildHeaderIcon(
                        Icons.notifications_none,

                        hasBadge: true,
                      ),
                      const SizedBox(width: 10),
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
                child: SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal, // ✅ left-right scroll
                    physics: const BouncingScrollPhysics(), // smooth iOS feel
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      _buildCategoryItem(
                        "English",
                        Icons.menu_book_outlined,
                        Colors.indigo,
                      ),
                      _buildCategoryItem("Math", Icons.calculate, Colors.blue),
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
                ),
              ),

              // Daily Quiz Card
              // 🔥 Daily Quiz Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 160,
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
                  ),
                ),
              ),

              // ✅ Categories UNDER Daily Quiz
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  // padding: const EdgeInsets.all(1),
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
                  child: CategorySection(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        username: username,
      ),
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
              child: Center(
                child: const Text(
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
            Text(
              title,
              style: AppTheme.categoryTitle,
            ),

            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 80,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.caption.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }




}
