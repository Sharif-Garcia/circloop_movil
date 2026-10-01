import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Contenedor blanco con borde y sombra suave. Se usa para agrupar
/// formularios o bloques de contenido.
class AppTarjeta extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppTarjeta({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.lg),
  });

  @override
  Widget build(BuildContext context) {
    // Blanca y con borde normal por defecto; FondoEco la vuelve translúcida
    // y con borde suave vía cardTheme
    final temaTarjeta = Theme.of(context).cardTheme;
    final forma = temaTarjeta.shape;
    final colorBorde = forma is RoundedRectangleBorder
        ? forma.side.color
        : AppColors.border;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: temaTarjeta.color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: colorBorde),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
