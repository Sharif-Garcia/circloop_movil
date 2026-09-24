import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  void _cerrarSesion(BuildContext context, WidgetRef ref) {
    ref.read(authProvider.notifier).cerrarSesion();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        _cerrarSesion(context, ref);
      },
      icon: const Icon(Icons.logout),
      tooltip: 'Cerrar sesión',
    );
  }
}
