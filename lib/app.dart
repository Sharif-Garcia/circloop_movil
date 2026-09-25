import 'package:circloop_movil/screens/splash/splash_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/utils/app_theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.nombreApp,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
