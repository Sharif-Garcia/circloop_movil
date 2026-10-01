import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../widgets/comunes/app_logo.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _duracion = Duration(seconds: 3);
  static const Duration _duracionEntrada = Duration(milliseconds: 1400);

  /// Escala con la que aparece el logo antes de crecer a su tamaño final.
  static const double _escalaInicial = 0.8;

  // La splash nativa es solo el color de fondo. Primero el logo aparece en el
  // centro (fundido + escala) y luego sube mientras aparecen los textos.
  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: _duracionEntrada,
  );
  late final Animation<double> _opacidadLogo = CurvedAnimation(
    parent: _entrada,
    curve: const Interval(0, 0.4, curve: Curves.easeOut),
  );
  late final Animation<double> _escalaLogo =
      Tween<double>(begin: _escalaInicial, end: 1).animate(
        CurvedAnimation(
          parent: _entrada,
          curve: const Interval(0, 0.5, curve: Curves.easeOutBack),
        ),
      );
  late final Animation<double> _espacioTextos = CurvedAnimation(
    parent: _entrada,
    curve: const Interval(0.4, 0.9, curve: Curves.easeInOutCubic),
  );
  late final Animation<double> _opacidadTextos = CurvedAnimation(
    parent: _entrada,
    curve: const Interval(0.55, 1, curve: Curves.easeOut),
  );

  bool _iniciada = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precacheImage necesita el context, que en initState aún no está listo
    if (_iniciada) return;
    _iniciada = true;
    _iniciar();
  }

  @override
  void dispose() {
    _entrada.dispose();
    super.dispose();
  }

  Future<void> _iniciar() async {
    // Espera a que el logo esté decodificado antes de quitar la splash
    // nativa, para que la animación empiece con el logo ya listo.
    await precacheImage(const AssetImage(AppImages.logo), context);
    FlutterNativeSplash.remove();
    if (!mounted) return;

    await _entrada.forward();
    await Future.delayed(_duracion - _duracionEntrada);
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
      body: Stack(
        children: [
          // El bloque de textos crece desde 0, así el logo aparece en el
          // centro exacto y luego sube suavemente hasta su posición final.
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _opacidadLogo,
                  child: ScaleTransition(
                    scale: _escalaLogo,
                    child: const AppLogo(),
                  ),
                ),
                SizeTransition(
                  sizeFactor: _espacioTextos,
                  alignment: Alignment.topCenter,
                  child: FadeTransition(
                    opacity: _opacidadTextos,
                    child: const Column(
                      children: [
                        SizedBox(height: AppSizes.lg),
                        Text(
                          AppStrings.nombreApp,
                          style: TextStyle(
                            fontSize: AppSizes.textTitle,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: AppSizes.sm),
                        Text(
                          AppStrings.eslogan,
                          style: TextStyle(
                            fontSize: AppSizes.textSm,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.lg),
                child: FadeTransition(
                  opacity: _opacidadTextos,
                  child: const Text(
                    AppStrings.piePlataforma,
                    style: TextStyle(
                      fontSize: AppSizes.textXs,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
