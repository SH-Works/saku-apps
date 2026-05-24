import 'package:flutter/material.dart';

import '../core/config/flavor_config.dart';
import 'router.dart';
import 'theme.dart';

class SakuApp extends StatelessWidget {
  const SakuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: FlavorConfig.instance.appTitle,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
