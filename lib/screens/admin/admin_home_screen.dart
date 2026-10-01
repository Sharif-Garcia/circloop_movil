import 'package:circloop_movil/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador'),
        actions: const [LogoutButton()],
      ),
      body: const Center(child: Text('Panel de Administrador')),
    );
  }
}
