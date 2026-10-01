import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_sizes.dart';

/// Fondo de las pantallas de autenticación: la ilustración del paisaje
/// (`AppImages.fondo`) cubriendo toda la pantalla, con el contenido encima.
///
/// Envuelve un `Scaffold` con `backgroundColor: AppColors.transparente`. Dentro
/// de él, los campos de texto y las `AppTarjeta` se vuelven blancos
/// translúcidos con bordes suaves (vía el tema), para que se vea el paisaje
/// sin perder legibilidad.
class FondoEco extends StatelessWidget {
  final Widget child;

  const FondoEco({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final borde = AppColors.border.withValues(alpha: 0.5);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AppImages.fondo,
            fit: BoxFit.cover,
            // Si la imagen falta, queda el color de fondo normal de la app
            errorBuilder: (context, error, stackTrace) =>
                const ColoredBox(color: AppColors.background),
          ),
        ),
        SafeArea(
          child: Theme(
            data: tema.copyWith(
              inputDecorationTheme: tema.inputDecorationTheme.copyWith(
                fillColor: AppColors.superficieTranslucida,
                border: _bordeCampo(borde),
                enabledBorder: _bordeCampo(borde),
                focusedBorder: _bordeCampo(AppColors.primary, ancho: 1.5),
                errorBorder: _bordeCampo(AppColors.error),
                focusedErrorBorder: _bordeCampo(AppColors.error, ancho: 1.5),
              ),
              cardTheme: tema.cardTheme.copyWith(
                color: AppColors.superficieTranslucida,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  side: BorderSide(color: borde),
                ),
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  static OutlineInputBorder _bordeCampo(Color color, {double ancho = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      borderSide: BorderSide(color: color, width: ancho),
    );
  }
}
