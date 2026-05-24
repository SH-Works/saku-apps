class TransactionCategory {
  final String id;
  final String label;
  final String icon;

  const TransactionCategory({
    required this.id,
    required this.label,
    required this.icon,
  });
}

const List<TransactionCategory> kCategories = [
  TransactionCategory(id: 'food', label: 'Makanan', icon: '🍽️'),
  TransactionCategory(id: 'drink', label: 'Minuman', icon: '🍺'),
  TransactionCategory(id: 'coffee', label: 'Kopi', icon: '☕️'),
  TransactionCategory(id: 'mineral_water', label: 'Air Mineral', icon: '💧'),
  TransactionCategory(id: 'cigar', label: 'Rokok', icon: '🚬'),
  TransactionCategory(id: 'fuel', label: 'Bensin', icon: '⛽️'),
  TransactionCategory(id: 'transport', label: 'Transportasi', icon: '🚗'),
  TransactionCategory(id: 'internet_wifi', label: 'Internet Wifi', icon: '🌐'),
  TransactionCategory(id: 'quota', label: 'Kuota', icon: '📱'),
  TransactionCategory(id: 'toiletries', label: 'Perlengkapan Mandi', icon: '🧼'),
  TransactionCategory(id: 'rent', label: 'Sewa', icon: '🏠'),
  TransactionCategory(id: 'snack', label: 'Cemilan', icon: '🍫'),
  TransactionCategory(id: 'street_food', label: 'Jajan', icon: '🍜'),
  TransactionCategory(id: 'shopping', label: 'Belanja', icon: '🛍️'),
  TransactionCategory(id: 'salary', label: 'Gaji', icon: '💼'),
  TransactionCategory(id: 'bonus', label: 'Bonus', icon: '🎁'),
  TransactionCategory(id: 'other', label: 'Lainnya', icon: '📦'),
];

TransactionCategory categoryById(String id) {
  return kCategories.firstWhere(
    (c) => c.id == id,
    orElse: () => const TransactionCategory(
      id: 'other',
      label: 'Lainnya',
      icon: '📦',
    ),
  );
}
