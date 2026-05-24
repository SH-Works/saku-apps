/// Formats an integer amount in IDR with dots as thousand separators.
///
/// Example:
///   formatRupiah(1250000) -> "Rp 1.250.000"
///   formatRupiah(3251606) -> "Rp 3.251.606"
String formatRupiah(int amount) {
  final isNegative = amount < 0;
  final absStr = amount.abs().toString();
  final formatted = absStr.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
  return '${isNegative ? '-' : ''}Rp $formatted';
}

/// Parses a Rupiah-formatted string back to an integer.
/// Strips all non-digit characters except a leading minus.
int parseRupiah(String text) {
  if (text.isEmpty) return 0;
  final isNegative = text.trim().startsWith('-');
  final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return 0;
  final value = int.tryParse(digits) ?? 0;
  return isNegative ? -value : value;
}
