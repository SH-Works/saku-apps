import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/search/presentation/pages/search_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/transaction/presentation/pages/history_page.dart';
import '../features/transaction/presentation/pages/home_page.dart';
import '../features/transaction/presentation/pages/report_page.dart';
import '../features/wallets/presentation/pages/wallet_detail_page.dart';
import '../features/wallets/presentation/pages/wallets_page.dart';
import 'main_shell.dart';

// ignore_for_file: unnecessary_underscores

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
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
        // /add is handled as a modal sheet from MainShell, but we still
        // register the route so deep-links don't 404.
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
