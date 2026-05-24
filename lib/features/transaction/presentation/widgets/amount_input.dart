import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Large display for the transaction amount with a custom numeric keypad.
class AmountInput extends StatelessWidget {
  final int amount;
  final ValueChanged<int> onChanged;

  const AmountInput({
    super.key,
    required this.amount,
    required this.onChanged,
  });

  void _appendDigit(String digit) {
    if (amount == 0 && digit == '0') return;
    final next = amount.toString() + digit;
    final parsed = int.tryParse(next) ?? amount;
    if (parsed > 9999999999) return;
    onChanged(parsed);
  }

  void _backspace() {
    if (amount == 0) return;
    final str = amount.toString();
    if (str.length <= 1) {
      onChanged(0);
    } else {
      onChanged(int.parse(str.substring(0, str.length - 1)));
    }
  }

  void _clear() => onChanged(0);

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formatRupiah(amount),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: fg,
                letterSpacing: -1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _Keypad(
          onTapDigit: _appendDigit,
          onBackspace: _backspace,
          onClear: _clear,
        ),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onTapDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  const _Keypad({
    required this.onTapDigit,
    required this.onBackspace,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['C', '0', '⌫'],
    ];
    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: row.map((k) {
              VoidCallback action;
              if (k == 'C') {
                action = onClear;
              } else if (k == '⌫') {
                action = onBackspace;
              } else {
                action = () => onTapDigit(k);
              }
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _KeypadButton(label: k, onTap: action),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeypadButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final fg = isDark ? AppColors.white : AppColors.black;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: SizedBox(
          height: 56,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
