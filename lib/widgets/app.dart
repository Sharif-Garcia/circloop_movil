import 'package:circloop_movil/screens/auth/login_screen.dart';
import 'package:circloop_movil/utils/app_theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIRCLOOP',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
