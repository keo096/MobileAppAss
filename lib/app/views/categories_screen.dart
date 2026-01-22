import 'package:flutter/material.dart';
import 'package:smart_quiz/app/models/category_model.dart';

class CategorySection extends StatefulWidget {
  final String role;
  const CategorySection({super.key, required this.role});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  bool isExpanded = true;

  final List<Category> categories = [
    Category(
      title: "Present Simple",
      subtitle: "English Tense",
      progress: 0.65,
      icon: Icons.menu_book,
      color: Colors.deepPurple,
    ),
    Category(
      title: "Khmer History",
      subtitle: "History",
      progress: 0.50,
      icon: Icons.history_edu,
      color: Colors.brown,
    ),
    Category(
      title: "Function Complex",
      subtitle: "Math",
      progress: 0.30,
      icon: Icons.calculate,
      color: Colors.blue,
    ),
    Category(
      title: "Khmer Culture",
      subtitle: "General Knowledge",
      progress: 0.80,
      icon: Icons.account_balance,
      color: Colors.purple,
    ),
    Category(
      title: "Chemistry Experiment",
      subtitle: "Chemistry",
      progress: 0.95,
      icon: Icons.science,
      color: Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 1️⃣ Header (No background)
       Container(
  // 1. Add the background color and round the top corners to match the card
  decoration: const BoxDecoration(
    color: Colors.deepPurple, // 👈 Your background color
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(22), 
      topRight: Radius.circular(22),
    ),
  ),
  child: Padding(
    // 2. Adjust padding so the text isn't touching the purple edges
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recently quizes",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 224, 221, 221), 
            letterSpacing: 2,
            fontFamily: 'SFPro',
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: AnimatedRotation(
            turns: isExpanded ? 0.0 : 0.5,
            duration: const Duration(milliseconds: 250),
            child: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.white, // 👈 Change to white to match the text
              size: 28,
            ),
          ),
        ),
      ],
    ),
  ),
),

        const SizedBox(height: 12),

        /// 2️⃣ Background only for category cards
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            // color: const Color.fromARGB(120, 255, 255, 255),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(categories[index]);
                    },
                  )
                : const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                color: category.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Icon(category.icon, color: Colors.white, size: 40),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                                category.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                category.subtitle,
                                style: const TextStyle(
                                  color: Color.fromARGB(196, 0, 0, 0),
                                  fontSize: 13,
                                  fontFamily: 'SFPro',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              // Users can only view, admin can edit
                              if (widget.role == 'admin') {
                                // Show edit/delete options for admin
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Admin: Edit/Delete options available"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                // Regular user can only view
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Viewing quiz results"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              widget.role == 'admin' ? "Manage" : "View result",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
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
                              value: category.progress,
                              backgroundColor: Colors.grey.shade200,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                Colors.deepPurple,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${(category.progress * 100).toInt()}%",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'SFPro',
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
}
