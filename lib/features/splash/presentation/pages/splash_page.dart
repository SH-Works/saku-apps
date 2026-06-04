import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Controls the full-screen fade-out before navigation
  double _opacity = 1.0;
  static const _fadeOutDuration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();

    // Step 1 — after 1s, start fade-out
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() => _opacity = 0.0);

      // Step 2 — after fade-out completes, navigate
      Future.delayed(_fadeOutDuration, () {
        if (mounted) context.go('/home');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: _fadeOutDuration,
        curve: Curves.easeOut,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/Loading2.json',
                width: 600,
                height: 600,
                fit: BoxFit.contain,
                repeat: true,
                backgroundLoading: true,
                delegates: const LottieDelegates(values: []),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
