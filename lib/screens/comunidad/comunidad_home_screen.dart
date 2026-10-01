import 'package:circloop_movil/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class ComunidadHomeScreen extends StatelessWidget {
  const ComunidadHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        actions: const [LogoutButton()],
      ),
      body: const Center(child: Text('Panel de Comunidad')),
    );
  }
}
