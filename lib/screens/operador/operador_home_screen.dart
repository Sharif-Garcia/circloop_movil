import 'package:circloop_movil/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class OperadorHomeScreen extends StatelessWidget {
  const OperadorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operador'),
        actions: const [LogoutButton()],
      ),
      body: const Center(child: Text('Panel de Operador')),
    );
  }
}
