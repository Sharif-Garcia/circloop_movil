import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../widgets/comunes/app_logo.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _duracion = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _irASiguientePantalla();
  }

  Future<void> _irASiguientePantalla() async {
    await Future.delayed(_duracion);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hereda el color de fondo AppColors.background desde AppTheme
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              const AppLogo(),

              const SizedBox(height: AppSizes.lg),

              const Text(
                AppStrings.nombreApp,
                style: TextStyle(
                  fontSize: AppSizes.textTitle,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: AppSizes.sm),

              const Text(
                AppStrings.eslogan,
                style: TextStyle(
                  fontSize: AppSizes.textSm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),

              const Spacer(),

              const Padding(
                padding: EdgeInsets.only(bottom: AppSizes.lg),
                child: Text(
                  AppStrings.piePlataforma,
                  style: TextStyle(
                    fontSize: AppSizes.textXs,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
