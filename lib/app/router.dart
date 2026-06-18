import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/budget/presentation/pages/add_budget_page.dart';
import '../features/budget/presentation/pages/budget_page.dart';
import '../features/recuring/presentation/pages/add_recurring_page.dart';
import '../features/recuring/presentation/pages/recuring_page.dart';
import '../features/search/presentation/pages/search_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/smoke_tracker/presentation/pages/smoke_settings_page.dart';
import '../features/smoke_tracker/presentation/pages/smoke_statistics_page.dart';
import '../features/smoke_tracker/presentation/pages/smoke_tracker_page.dart';
import '../features/smoke_tracker/presentation/providers/smoke_provider.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/transfer/presentation/pages/transfer_history_page.dart';
import '../features/transaction/presentation/pages/history_page.dart';
import '../features/transaction/presentation/pages/home_page.dart';
import '../features/transaction/presentation/pages/report_page.dart';
import '../features/wallets/presentation/pages/wallet_detail_page.dart';
import '../features/wallets/presentation/pages/wallets_page.dart';
import 'main_shell.dart';

// ignore_for_file: unnecessary_underscores

String? _smokeRouteGuard(BuildContext context) {
  try {
    final container = ProviderScope.containerOf(context);
    final enabled = container.read(smokeTrackerEnabledProvider);
    return enabled ? null : '/home';
  } catch (_) {
    return '/home';
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: '/transfers',
      builder: (_, state) => TransferHistoryPage(
        walletId: state.uri.queryParameters['walletId'],
      ),
    ),
    GoRoute(
      path: '/budget',
      builder: (_, __) => const BudgetPage(),
    ),
    GoRoute(
      path: '/budget/add',
      builder: (_, __) => const AddBudgetPage(),
    ),
    GoRoute(
      path: '/recuring',
      builder: (_, __) => const RecuringPage(),
    ),
    GoRoute(
      path: '/recuring/add',
      builder: (_, __) => const AddRecurringPage(),
    ),
    GoRoute(
      path: '/smoke',
      redirect: (context, state) => _smokeRouteGuard(context),
      builder: (_, __) => const SmokeTrackerPage(),
    ),
    GoRoute(
      path: '/smoke/stats',
      redirect: (context, state) => _smokeRouteGuard(context),
      builder: (_, __) => const SmokeStatisticsPage(),
    ),
    GoRoute(
      path: '/smoke/settings',
      redirect: (context, state) => _smokeRouteGuard(context),
      builder: (_, __) => const SmokeSettingsPage(),
    ),
    GoRoute(
      path: '/search',
      builder: (_, __) => const SearchPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (_, __) => const SettingsPage(),
    ),
    GoRoute(
      path: '/wallets',
      builder: (_, __) => const WalletsPage(),
    ),
    GoRoute(
      path: '/wallets/:id',
      builder: (_, state) =>
          WalletDetailPage(walletId: state.pathParameters['id']!),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomePage(),
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: Duration.zero,
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn,
              ),
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: '/add',
          pageBuilder: (_, __) => const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: HistoryPage()),
        ),
        GoRoute(
          path: '/report',
          pageBuilder: (_, __) => const NoTransitionPage(child: ReportPage()),
        ),
      ],
    ),
  ],
);
