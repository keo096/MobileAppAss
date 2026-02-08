import 'package:flutter/material.dart';
import 'package:smart_quiz/data/models/category_model.dart';
import 'package:smart_quiz/features/category/presentation/providers/category_provider.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  final CategoryProvider categoryProvider;

  const AddCategoryBottomSheet({super.key, required this.categoryProvider});

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();

  // Available icons for selection
  final List<IconData> _availableIcons = [
    Icons.menu_book,
    Icons.history_edu,
    Icons.calculate,
    Icons.account_balance,
    Icons.science,
    Icons.computer,
    Icons.language,
    Icons.music_note,
    Icons.sports_soccer,
    Icons.palette,
    Icons.public,
    Icons.psychology,
  ];

  IconData _selectedIcon = Icons.menu_book;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 24,
        right: 24,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'New Category',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack87,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),

          // Title Input
          _buildInputField(
            controller: _titleController,
            label: 'Category Title',
            icon: Icons.title,
          ),
          const SizedBox(height: 16),

          // Subtitle Input
          _buildInputField(
            controller: _subtitleController,
            label: 'Subtitle (Optional)',
            icon: Icons.subtitles,
          ),

          const SizedBox(height: 24),
          const Text(
            'Icon',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack87,
            ),
          ),
          const SizedBox(height: 12),

          // Icon Selection
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _availableIcons.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final icon = _availableIcons[index];
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.categoryPurple
                          : AppColors.backgroundLightGrey,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: AppColors.categoryPurple,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final newCategory = Category(
                    title: _titleController.text,
                    subtitle: _subtitleController.text.isEmpty
                        ? 'General'
                        : _subtitleController.text,
                    progress: 0.0,
                    icon: _selectedIcon,
                    color:
                        Colors.primaries[DateTime.now().millisecond %
                            Colors.primaries.length],
                  );

                  widget.categoryProvider.addCategory(newCategory);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.categoryPurple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: AppColors.categoryPurple.withOpacity(0.5),
              ),
              child: const Text(
                'Create Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundLightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
