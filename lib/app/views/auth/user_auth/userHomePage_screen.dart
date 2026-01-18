import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smart_quiz/app/views/auth/user_auth/userProfile_screen.dart';
import 'package:smart_quiz/app/views/categories_screen.dart';

class UserHomePage extends StatelessWidget {
  final String username;
  const UserHomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A2CA0), Color(0xFFB59AD8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
                        backgroundImage: AssetImage('assets/images/pf.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, $username 👋",
                            style: const TextStyle(
                              fontFamily: 'SFPro',
                              color: Colors.white,
                              fontSize: 25,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Text(
                            "Ready to learn today?",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontFamily: 'SFPro',
                            ),
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
                              hintText:
                                  "Search topics, quizzes, or subjects...",
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'SFPro',
                                fontSize: 18,
                              ),
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
              _buildSectionTitle("Select your Category"),
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
                      buildQuizCard(
                        title: "Daily Quiz Challenge",
                        subtitle: "15 Questions • 7-10mins",
                        imagePath: "assets/images/imgcopy.png",
                        buttonText: "Start Now",
                      ),
                      buildQuizCard(
                        title: "Learnig Goals",
                        subtitle:
                            "Choose how many quizzes you want to finish each week",
                        imagePath: "assets/images/imagecopyGoal.png",
                        buttonText: "Set Goal",
                      ),
                      buildQuizCard(
                        title: "Complete With Friends",
                        subtitle:
                            "See how your rank compares on the leaderboard",
                        imagePath: "assets/images/imagecopyProgress.png",
                        buttonText: "View Leaderboard",
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
                    color: const Color.fromARGB(
                      120,
                      255,
                      255,
                      255,
                    ), // 👈 Background color for the whole section
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(Icons.home, "Home", isSelected: true),
              const SizedBox(width: 4),
              _buildNavIcon(Icons.history, "History"),
              const SizedBox(width: 4), 
              _buildNavIcon(Icons.category_outlined, "Category"),
              const SizedBox(width: 4), 
              _buildNavIcon(Icons.emoji_events, "Leader Board"),
              const SizedBox(width: 4),
              _buildNavIcon(Icons.person, "Profile"),
            ],
          ),
        ),
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
              style: const TextStyle(
                color: Color.fromARGB(255, 224, 221, 221),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFPro',
                letterSpacing: 1,
              ),
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'SFPro',
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningCard(String title, String subtitle, double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'SFPro',
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontFamily: 'SFPro',
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text(
              "Resume",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'SFPro',
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildNavIcon(IconData icon, String label, {bool isSelected = false}) {
  return Builder(
    builder: (context) {
      return InkWell(
        onTap: () {
          if (label == "Profile") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.deepPurple : Colors.black,
              size: 28,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.deepPurple : Colors.black,
                fontSize: 13,
                fontFamily: 'SFPro',
              ),
            ),
          ],
        ),
      );
    },
  );
}



Widget buildQuizCard({
  required String title,
  required String subtitle,
  required String imagePath,
  required String buttonText,
}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 166, 93, 197),
          Color.fromARGB(255, 149, 34, 250),
        ],
      ),
      borderRadius: BorderRadius.circular(30),
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.2),
      //     blurRadius: 10,
      //     offset: const Offset(0, 5),
      //   ),
      // ],
    ),

    child: Row(
      children: [
        Image.asset(imagePath, width: 100, height: 100),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontFamily: 'SFPro',
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'SFPro',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}