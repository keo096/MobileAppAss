import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/constants/app_assets.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/core/widgets/bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurpleAccent,
      body: SafeArea(
        child: Column(
          children: [
            // Top Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundImage: AssetImage(AppAssets.profileImage),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Chheangly Hok",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "chheanglyhok@gmail.com",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 18),
                    label: Text(AppStrings.editProfile),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.25),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ),

            // Performance Summary Card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.performanceSummary,
                            style: AppTheme.headingSmall,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _summaryBox(
                                  icon: Icons.star,
                                  title: "XP / Level",
                                  value: "2,300 XP",
                                  subtitle: "Level 5",
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 10),
                                _summaryBox(
                                  icon: Icons.timer,
                                  title: "Time Spent",
                                  value: "1h 30m",
                                  subtitle: "",
                                  color: Colors.purple,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _summaryBox(
                                  icon: Icons.check_circle,
                                  title: "Completed Quizzes",
                                  value: "105 Quizzes",
                                  subtitle: "",
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                _summaryBox(
                                  icon: Icons.bar_chart,
                                  title: "Overall Grade",
                                  value: "82%",
                                  subtitle: "B",
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // More Section
                      _menuItem(Icons.emoji_events, AppStrings.myAchievements),
                      _menuItem(Icons.save_alt, AppStrings.savedQuizzes),
                      _menuItem(Icons.settings, AppStrings.appSettings),
                      _menuItem(Icons.help, AppStrings.helpSupport),
                      _menuItem(Icons.logout, AppStrings.logout),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  // Summary Box Widget
  Widget _summaryBox({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 6),
                Text(title, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (subtitle.isNotEmpty)
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // Menu Item Widget
  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
