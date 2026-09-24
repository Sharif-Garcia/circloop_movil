import 'package:circloop_movil/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class PuntoCanjeHomeScreen extends StatelessWidget {
  const PuntoCanjeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Canje'),
        actions: const [LogoutButton()],
      ),
      body: const Center(child: Text('Panel de Punto de Canje')),
    );
  }
}
