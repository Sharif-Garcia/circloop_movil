import 'package:flutter/material.dart';

import '../../models/onboarding_paso.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../widgets/comunes/app_marca.dart';
import '../../widgets/botones/boton_primario.dart';
import '../../widgets/comunes/etiqueta.dart';
import '../../widgets/comunes/indicador_paginas.dart';
import '../../widgets/onboarding/ilustracion_paso.dart';
import '../auth/login_screen.dart';
import 'onboarding_pasos.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Duration _duracionCambio = Duration(milliseconds: 350);

  final _paginas = PageController();
  int _pasoActual = 0;

  bool get _esUltimoPaso => _pasoActual == pasosOnboarding.length - 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Deja decodificado el fondo del login para que aparezca sin parpadeo
    precacheImage(const AssetImage(AppImages.fondo), context);
  }

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  void _siguientePaso() {
    if (_esUltimoPaso) {
      _irALogin();
      return;
    }

    _paginas.nextPage(duration: _duracionCambio, curve: Curves.easeInOutCubic);
  }

  void _irALogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Encabezado ("Saltar" desaparece en el último paso)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppMarca(),
                    AnimatedOpacity(
                      opacity: _esUltimoPaso ? 0 : 1,
                      duration: _duracionCambio,
                      child: TextButton(
                        onPressed: _esUltimoPaso ? null : _irALogin,
                        child: const Text(AppStrings.saltar),
                      ),
                    ),
                  ],
                ),
              ),

              // Pasos: se pueden deslizar o avanzar con el botón
              Expanded(
                child: PageView.builder(
                  controller: _paginas,
                  itemCount: pasosOnboarding.length,
                  onPageChanged: (indice) =>
                      setState(() => _pasoActual = indice),
                  itemBuilder: (context, indice) =>
                      _pagina(pasosOnboarding[indice], indice),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IndicadorPaginas(
                      total: pasosOnboarding.length,
                      actual: _pasoActual,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    BotonPrimario(
                      texto: _esUltimoPaso
                          ? AppStrings.comenzar
                          : AppStrings.siguiente,
                      onPressed: _siguientePaso,
                      iconoFinal: Icons.arrow_forward_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pagina(OnboardingPaso paso, int indice) {
    final textos = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            IlustracionPaso(
              imagen: paso.imagen,
              icono: paso.icono,
              color: paso.color,
              iconosSecundarios: paso.iconosSecundarios,
            ),
            const SizedBox(height: AppSizes.xl),
            Etiqueta(
              texto:
                  '${AppStrings.pasoDe(indice + 1, pasosOnboarding.length)} · ${paso.etiqueta}',
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSizes.md),
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
          ],
        ),
      ),
    );
  }
}
