import 'package:hugeicons/hugeicons.dart';

class TransactionCategory {
  final String id;
  final String label;
  final List<List<dynamic>> icon;

  const TransactionCategory({
    required this.id,
    required this.label,
    required this.icon,
  });
}

const List<TransactionCategory> kCategories = [
  TransactionCategory(
      id: 'food',
      label: 'Makanan',
      icon: HugeIcons.strokeRoundedRestaurant01),
  TransactionCategory(
      id: 'drink', label: 'Minuman', icon: HugeIcons.strokeRoundedDrink),
  TransactionCategory(
      id: 'coffee', label: 'Kopi', icon: HugeIcons.strokeRoundedCoffee01),
  TransactionCategory(
      id: 'mineral_water',
      label: 'Air Mineral',
      icon: HugeIcons.strokeRoundedSodaCan),
  TransactionCategory(
      id: 'cigar',
      label: 'Rokok',
      icon: HugeIcons.strokeRoundedCigarette),
  TransactionCategory(
      id: 'fuel',
      label: 'Bensin',
      icon: HugeIcons.strokeRoundedFuelStation),
  TransactionCategory(
      id: 'transport',
      label: 'Transportasi',
      icon: HugeIcons.strokeRoundedCar01),
  TransactionCategory(
      id: 'internet_wifi',
      label: 'Internet Wifi',
      icon: HugeIcons.strokeRoundedWifi01),
  TransactionCategory(
      id: 'quota',
      label: 'Kuota',
      icon: HugeIcons.strokeRoundedSmartPhone01),
  TransactionCategory(
      id: 'toiletries',
      label: 'Perlengkapan Mandi',
      icon: HugeIcons.strokeRoundedShampoo),
  TransactionCategory(
      id: 'rent',
      label: 'Sewa',
      icon: HugeIcons.strokeRoundedBuilding01),
  TransactionCategory(
      id: 'snack',
      label: 'Cemilan',
      icon: HugeIcons.strokeRoundedCupcake01),
  TransactionCategory(
      id: 'street_food',
      label: 'Jajan',
      icon: HugeIcons.strokeRoundedNoodles),
  TransactionCategory(
      id: 'shopping',
      label: 'Belanja',
      icon: HugeIcons.strokeRoundedShoppingBag01),
  TransactionCategory(
      id: 'salary',
      label: 'Gaji',
      icon: HugeIcons.strokeRoundedMoney01),
  TransactionCategory(
      id: 'bonus',
      label: 'Bonus',
      icon: HugeIcons.strokeRoundedGiftCard),
  TransactionCategory(
      id: 'other',
      label: 'Lainnya',
      icon: HugeIcons.strokeRoundedPackage),
];

TransactionCategory categoryById(String id) {
  return kCategories.firstWhere(
    (c) => c.id == id,
    orElse: () => const TransactionCategory(
      id: 'other',
      label: 'Lainnya',
      icon: HugeIcons.strokeRoundedPackage,
    ),
  );
}
