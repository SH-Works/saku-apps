import 'package:go_router/go_router.dart';

import '../features/splash/presentation/pages/splash_page.dart';
import '../features/transaction/presentation/pages/history_page.dart';
import '../features/transaction/presentation/pages/home_page.dart';
import '../features/transaction/presentation/pages/report_page.dart';
import 'main_shell.dart';

// ignore_for_file: unnecessary_underscores

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (_, __) => const NoTransitionPage(child: HomePage()),
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
