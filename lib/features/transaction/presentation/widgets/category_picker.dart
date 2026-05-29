import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/categories.dart';

class CategoryPicker extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<String> onSelected;

  const CategoryPicker({
    super.key,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final selectedBg = isDark ? AppColors.white : AppColors.black;
    final selectedFg = isDark ? AppColors.black : AppColors.white;
    final defaultFg = isDark ? AppColors.white : AppColors.black;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemCount: kCategories.length,
      itemBuilder: (context, index) {
        final cat = kCategories[index];
        final isSelected = cat.id == selectedCategoryId;
        return Material(
          color: isSelected ? selectedBg : defaultBg,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onSelected(cat.id),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: cat.icon,
                    color: isSelected ? selectedFg : defaultFg,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat.label,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? selectedFg : defaultFg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
