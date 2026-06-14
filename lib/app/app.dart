import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/flavor_config.dart';
import '../features/recuring/presentation/providers/recuring_provider.dart';
import '../features/settings/presentation/providers/settings_provider.dart';
import 'router.dart';
import 'theme.dart';

class SakuApp extends ConsumerStatefulWidget {
  const SakuApp({super.key});

  @override
  ConsumerState<SakuApp> createState() => _SakuAppState();
}

class _SakuAppState extends ConsumerState<SakuApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(processDueRecurringProvider).call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(settingsProvider.select((s) => s.themeMode));

    return MaterialApp.router(
      title: FlavorConfig.instance.appTitle,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
