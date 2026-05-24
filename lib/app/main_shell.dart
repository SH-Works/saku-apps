import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.tabHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: AppStrings.tabAdd,
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: AppStrings.tabHistory,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: AppStrings.tabReport,
          ),
        ],
      ),
    );
  }
}
