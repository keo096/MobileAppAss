import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_assets.dart';
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
            // ── Purple Header ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconBtn(Icons.close, () {}),
                  _iconBtn(Icons.settings_outlined, () {}),
                ],
              ),
            ),

            // Avatar + Name
            Column(
              children: [
                // Avatar with white ring
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage(AppAssets.profileImage),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Davin C. Resolve',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'chheanglyok@gmail.com',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

            // ── White Card ──────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA), // ream/off-white
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section: Performance Summary
                      const Text(
                        'Performance Summary',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Row 1
                      Row(
                        children: [
                          _statCard(
                              
                            icon: Icons.star_rounded,
                            iconColor: Colors.amber,
                            title: 'XP / Level',
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: '2,300 ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'XP',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  |  Level 5',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _statCard(
                            icon: Icons.timer_outlined,
                            iconColor: AppColors.primaryPurpleAccent,
                            title: 'Time Spent',
                            child: const Text(
                              '1h 30mn',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Row 2
                      Row(
                        children: [
                          _statCard(
                            icon: Icons.check_circle,
                            iconColor: Colors.green,
                            title: 'Completed Quizzes',
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: '105 ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Quizzes',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _statCard(
                            icon: Icons.bar_chart_rounded,
                            iconColor: Colors.orange,
                            title: 'Overall Grade',
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  '82%',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.bar_chart_rounded,
                                          size: 14, color: Colors.orange),
                                      SizedBox(width: 3),
                                      Text(
                                        'B',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Section: More
                      const Text(
                        'More',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Menu card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _menuItem(
                              icon: Icons.emoji_events_outlined,
                              title: 'My Achievements',
                            ),
                            _divider(),
                            _menuItem(
                              icon: Icons.bookmark_outline,
                              title: 'Saved Quizzes',
                            ),
                            _divider(),
                            _menuItem(
                              icon: Icons.settings_outlined,
                              title: 'App Settings',
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'English',
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 13),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.keyboard_arrow_down_rounded,
                                      color: Colors.black45, size: 20),
                                ],
                              ),
                            ),
                            _divider(),
                            _menuItem(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Logout (separate card, no chevron)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.logout,
                              color: Colors.black54, size: 22),
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 15, color: Colors.black87),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.20),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
      trailing: trailing ??
          const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.black45, size: 22),
      onTap: () {},
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        indent: 52,
        endIndent: 16,
        color: Colors.grey.shade100,
      );
}
