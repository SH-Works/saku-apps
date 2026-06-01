import 'package:flutter/material.dart';

import '../../../../app/theme.dart';

const List<String> kWalletIcons = [
  '💵', '🏦', '💳', '📱', '🏧', '💰',
  '👛', '🪙', '💼', '🏠', '🚗', '✈️',
  '🎓', '❤️', '⭐', '📦',
];

class WalletIconPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const WalletIconPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kWalletIcons.map((icon) {
        final isSelected = icon == selected;
        return GestureDetector(
          onTap: () => onSelected(icon),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : AppColors.secondary.withOpacity(0.2),
              ),
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(
                  fontSize: isSelected ? 22 : 20,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
