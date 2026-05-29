import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../core/constants/app_strings.dart';
import '../features/transaction/presentation/pages/add_transaction_page.dart';

/// Bottom-navigation shell that hosts the four primary tabs.
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _routes = ['/home', '/add', '/history', '/report'];

  int _indexFromLocation(String location) {
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    if (index == 1) {
      _openAddSheet(context);
      return;
    }
    context.go(_routes[index]);
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddTransactionPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    final selected = _indexFromLocation(location);

    // HugeIcon inherits color from NavigationBarTheme.iconTheme via IconTheme
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: const [
          NavigationDestination(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedHome01, size: 24),
            selectedIcon:
                HugeIcon(icon: HugeIcons.strokeRoundedHome01, size: 22),
            label: AppStrings.tabHome,
          ),
          NavigationDestination(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedPlusSign, size: 24),
            selectedIcon:
                HugeIcon(icon: HugeIcons.strokeRoundedPlusSign, size: 22),
            label: AppStrings.tabAdd,
          ),
          NavigationDestination(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedNote01, size: 24),
            selectedIcon:
                HugeIcon(icon: HugeIcons.strokeRoundedNote01, size: 22),
            label: AppStrings.tabHistory,
          ),
          NavigationDestination(
            icon:
                HugeIcon(icon: HugeIcons.strokeRoundedAnalytics01, size: 24),
            selectedIcon:
                HugeIcon(icon: HugeIcons.strokeRoundedAnalytics01, size: 22),
            label: AppStrings.tabReport,
          ),
        ],
      ),
    );
  }
}
