import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CategoryItem> filteredCategories = categories;

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((item) =>
              item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8E24AA),

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF8E24AA),
        automaticallyImplyLeading: false,
        title: const Text(
          "Categories",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.white,
            fontFamily: 'SFPro',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(165, 255, 255, 255),
                  ),
                  child: const Icon(
                    Icons.bookmark_outlined,
                    color: Colors.deepPurpleAccent,
                    size: 30,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "3",
                        style: TextStyle(
                          fontFamily: 'SFPro',
                          fontSize: 13,   
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ), 
          )
        ],
      ),

      /// BODY
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterCategories,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SFPro',
                  letterSpacing: 1,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  hintText: "Search categories...",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// WHITE BODY
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: GridView.builder(
                  itemCount: filteredCategories.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredCategories[index];
                    return _CategoryCard(
                      title: item.title,
                      icon: item.icon,
                      color: item.color,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CATEGORY CARD
class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 54,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'SFPro',
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

/// MODEL
class CategoryItem {
  final String title;
  final IconData icon;
  final Color color;

  CategoryItem(this.title, this.icon, this.color);
}

/// DATA
final List<CategoryItem> categories = [
  CategoryItem("English", Icons.menu_book, Colors.purple),
  CategoryItem("Math", Icons.calculate, Colors.blue),
  CategoryItem("Chemistry", Icons.science, Colors.teal),
  CategoryItem("History", Icons.history_edu, Colors.brown),
  CategoryItem("General Knowledge", Icons.auto_stories, Colors.deepPurple),
  CategoryItem("Physic", Icons.rocket_launch_outlined, Colors.indigo),
  CategoryItem("Biology", Icons.biotech, Colors.green),
  CategoryItem("Khmer", Icons.local_fire_department, Colors.red),
  CategoryItem("Geography", Icons.public, Colors.green),
  CategoryItem("Art", Icons.palette, Colors.purpleAccent),
  CategoryItem("Sport", Icons.sports_soccer, Colors.orange),
  CategoryItem("Technology", Icons.hub, Colors.blueAccent),
];
