import 'package:flutter/material.dart';
import 'package:smart_quiz/app/views/home_screen.dart';
import 'package:smart_quiz/app/views/history_screen.dart';
import 'package:smart_quiz/app/views/leaderboard_screen.dart';
import 'package:smart_quiz/app/views/auth/profile_screen.dart';
import 'package:smart_quiz/app/views/quiz_list_screen.dart';
import 'package:smart_quiz/app/views/dashboard/add_quiz_screen.dart';

class CategoriesFullScreen extends StatefulWidget {
  final String role;
  final String username;
  const CategoriesFullScreen({super.key, required this.role, required this.username});

  @override
  State<CategoriesFullScreen> createState() => _CategoriesFullScreenState();
}

class _CategoriesFullScreenState extends State<CategoriesFullScreen> {
  // Categories organized by type
  final Map<String, List<Map<String, dynamic>>> _categoriesByType = {
    'English': [
      {
        'title': 'English Grammar',
        'subtitle': 'Grammar and Language',
        'icon': Icons.menu_book,
        'color': Colors.deepPurple,
        'progress': 0.65,
      },
      {
        'title': 'English Vocabulary',
        'subtitle': 'Words and Phrases',
        'icon': Icons.book,
        'color': Colors.indigo,
        'progress': 0.45,
      },
    ],
    'Khmer': [
      {
        'title': 'Khmer History',
        'subtitle': 'Cambodian History',
        'icon': Icons.history_edu,
        'color': Colors.brown,
        'progress': 0.50,
      },
      {
        'title': 'Khmer Culture',
        'subtitle': 'Traditions and Customs',
        'icon': Icons.account_balance,
        'color': Colors.purple,
        'progress': 0.80,
      },
    ],
    'Chemistry': [
      {
        'title': 'Basic Chemistry',
        'subtitle': 'Fundamental Concepts',
        'icon': Icons.science,
        'color': Colors.teal,
        'progress': 0.95,
      },
      {
        'title': 'Organic Chemistry',
        'subtitle': 'Advanced Topics',
        'icon': Icons.science_outlined,
        'color': Colors.cyan,
        'progress': 0.60,
      },
    ],
    'Math': [
      {
        'title': 'Algebra',
        'subtitle': 'Equations and Functions',
        'icon': Icons.calculate,
        'color': Colors.blue,
        'progress': 0.30,
      },
      {
        'title': 'Geometry',
        'subtitle': 'Shapes and Angles',
        'icon': Icons.shape_line_outlined,
        'color': Colors.orange,
        'progress': 0.55,
      },
    ],
  };

  void _showAddCategoryDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController subtitleController = TextEditingController();
    IconData selectedIcon = Icons.category;
    Color selectedColor = Colors.deepPurple;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create New Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Category Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: subtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Subtitle',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                const Text('Select Icon:'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    Icons.menu_book,
                    Icons.calculate,
                    Icons.science,
                    Icons.history_edu,
                    Icons.account_balance,
                    Icons.psychology,
                  ].map((icon) {
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedIcon == icon
                              ? Colors.deepPurple.withOpacity(0.2)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedIcon == icon
                                ? Colors.deepPurple
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(icon),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
                const Text('Select Color:'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    Colors.deepPurple,
                    Colors.blue,
                    Colors.brown,
                    Colors.teal,
                    Colors.purple,
                    Colors.orange,
                  ].map((color) {
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color
                                ? Colors.black
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  // For now, add to a default category type
                  // In production, you'd let admin choose category type
                  setState(() {
                    if (!_categoriesByType.containsKey('New')) {
                      _categoriesByType['New'] = [];
                    }
                    _categoriesByType['New']!.add({
                      'title': titleController.text,
                      'subtitle': subtitleController.text.isEmpty
                          ? 'Category'
                          : subtitleController.text,
                      'progress': 0.0,
                      'icon': selectedIcon,
                      'color': selectedColor,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category created successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Create', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A2CA0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.role == 'admin' ? 'Manage Categories' : 'Categories',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: widget.role == 'admin'
            ? [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: _showAddCategoryDialog,
                ),
              ]
            : null,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A2CA0), Color(0xFFB59AD8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.category,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.role == 'admin'
                                  ? 'Create & Manage Categories'
                                  : 'Explore Categories',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.role == 'admin'
                                  ? 'Add new categories and manage existing ones'
                                  : 'Choose a category to start learning',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories List
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: _categoriesByType.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.role == 'admin'
                                    ? 'No categories yet.\nTap + to create one!'
                                    : 'No categories available',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _categoriesByType.length,
                          itemBuilder: (context, index) {
                            final categoryType = _categoriesByType.keys.toList()[index];
                            final categories = _categoriesByType[categoryType]!;
                            return _buildCategoryTypeSection(categoryType, categories);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.role == 'admin'
          ? FloatingActionButton(
              onPressed: _showAddCategoryDialog,
              backgroundColor: const Color(0xFF6A2CA0),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCategoryTypeSection(String categoryType, List<Map<String, dynamic>> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 15),
          child: Text(
            categoryType,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...categories.map((category) {
          return _buildCategoryCard(category, categoryType);
        }).toList(),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, String categoryType) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: category['color'] as Color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Icon(category['icon'] as IconData, color: Colors.white, size: 40),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category['title'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                category['subtitle'] as String,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontFamily: 'SFPro',
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.role == 'admin')
                          PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 20),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red, size: 20),
                                    SizedBox(width: 8),
                                    Text('Delete', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'delete') {
                                setState(() {
                                  _categoriesByType[categoryType]!.remove(category);
                                  if (_categoriesByType[categoryType]!.isEmpty) {
                                    _categoriesByType.remove(categoryType);
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Category deleted'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                              value: category['progress'] as double,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                category['color'] as Color,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${((category['progress'] as double) * 100).toInt()}%",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'SFPro',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (widget.role == 'admin')
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddQuizScreen(
                                      categoryName: categoryType,
                                      role: widget.role,
                                      username: widget.username,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add Quiz'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        if (widget.role == 'admin') const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to quiz list for this category type
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizListScreen(
                                    categoryName: categoryType,
                                    role: widget.role,
                                    username: widget.username,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: category['color'] as Color,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              widget.role == 'admin' ? 'View Quizzes' : 'View Quizzes',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.black,
      currentIndex: 2, // Category index
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                username: widget.username,
                role: widget.role,
              ),
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryScreen(
                role: widget.role,
                username: widget.username,
              ),
            ),
          );
        } else if (index == 2) {
          // Already on categories
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LeaderboardScreen(
                role: widget.role,
                username: widget.username,
              ),
            ),
          );
        } else if (index == 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                role: widget.role,
                username: widget.username,
              ),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: "Category"),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Leaderboard"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

