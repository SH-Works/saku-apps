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
  TransactionCategory(id: 'food', label: 'Food', icon: '🍽️'),
  TransactionCategory(id: 'drink', label: 'Drink', icon: '🍺'),
  TransactionCategory(id: 'coffee', label: 'Coffee', icon: '☕️'),
  TransactionCategory(id: 'mineral_water', label: 'Mineral Water', icon: '💧'),
  TransactionCategory(id: 'cigar', label: 'Cigar', icon: '🚬'),
  TransactionCategory(id: 'fuel', label: 'Fuel', icon: '⛽️'),
  TransactionCategory(id: 'transport', label: 'Transport', icon: '🚗'),
  TransactionCategory(id: 'internet_wifi', label: 'Internet Wifi', icon: '🌐'),
  TransactionCategory(id: 'quota', label: 'Quota', icon: '📱'),
  TransactionCategory(id: 'toiletries', label: 'Toiletries', icon: '🧼'),
  TransactionCategory(id: 'rent', label: 'Rent', icon: '🏠'),
  TransactionCategory(id: 'snack', label: 'Snack', icon: '🍫'),
  TransactionCategory(id: 'street_food', label: 'Street Food', icon: '🍜'),
  TransactionCategory(id: 'shopping', label: 'Shopping', icon: '🛍️'),
  TransactionCategory(id: 'salary', label: 'Salary', icon: '💼'),
  TransactionCategory(id: 'bonus', label: 'Bonus', icon: '🎁'),
  TransactionCategory(id: 'other', label: 'Others', icon: '📦'),
];

TransactionCategory categoryById(String id) {
  return kCategories.firstWhere(
    (c) => c.id == id,
    orElse: () => const TransactionCategory(
      id: 'other',
      label: 'Others',
      icon: '📦',
    ),
  );
}
