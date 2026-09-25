import 'package:flutter/material.dart';

import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../widgets/comunes/app_imagen.dart';
import '../../widgets/comunes/app_marca.dart';
import '../../widgets/botones/boton_primario.dart';
import '../../widgets/comunes/indicador_paginas.dart';
import '../auth/login_screen.dart';
import 'onboarding_pasos.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _pasoActual = 0;

  bool get _esUltimoPaso => _pasoActual == pasosOnboarding.length - 1;

  void _siguientePaso() {
    if (_esUltimoPaso) {
      _irALogin();
      return;
    }

    setState(() {
      _pasoActual++;
    });
  }

  void _irALogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paso = pasosOnboarding[_pasoActual];
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Encabezado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppMarca(),
                  TextButton(
                    onPressed: _irALogin,
                    child: const Text(AppStrings.saltar),
                  ),
                ],
              ),

              const Spacer(),

              AppImagen(
                ruta: paso.imagen,
                altura: AppSizes.ilustracion,
                iconoRespaldo: Icons.smart_toy,
              ),

              const SizedBox(height: AppSizes.xl),

              Text(
                paso.titulo,
                style: textos.headlineSmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.md),

              Text(
                paso.descripcion,
                style: textos.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.lg),

              IndicadorPaginas(
                total: pasosOnboarding.length,
                actual: _pasoActual,
              ),

              const Spacer(),

              BotonPrimario(
                texto: AppStrings.siguiente,
                onPressed: _siguientePaso,
              ),

              const SizedBox(height: AppSizes.md),

              Text(
                paso.pie,
                style: textos.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
