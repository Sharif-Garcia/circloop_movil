import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../comunes/app_tarjeta.dart';

/// "Tienes 1.100 pts [descripcion]" con un widget opcional a la derecha
/// (por ejemplo, cuántos premios alcanzan).
class TarjetaPuntos extends StatelessWidget {
  final int puntos;
  final String descripcion;
  final Widget? extremo;

  const TarjetaPuntos({
    super.key,
    required this.puntos,
    required this.descripcion,
    this.extremo,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return AppTarjeta(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          const Icon(
            Icons.star_rounded,
            color: AppColors.tertiary,
            size: AppSizes.iconLg,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.tienes, style: textos.bodySmall),
                Text(
                  AppStrings.puntos(Formatos.entero(puntos)),
                  style: textos.titleLarge?.copyWith(color: AppColors.tertiary),
                ),
                Text(descripcion, style: textos.bodySmall),
              ],
            ),
          ),
          ?extremo,
        ],
      ),
    );
  }
}
