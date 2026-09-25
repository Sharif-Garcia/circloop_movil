import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Puntos que indican en qué página de un carrusel o flujo por pasos se está.
class IndicadorPaginas extends StatelessWidget {
  final int total;
  final int actual;

  const IndicadorPaginas({
    super.key,
    required this.total,
    required this.actual,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final activo = index == actual;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
          height: AppSizes.indicadorAlto,
          width: activo
              ? AppSizes.indicadorAnchoActivo
              : AppSizes.indicadorAlto,
          decoration: BoxDecoration(
            color: activo ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(AppSizes.indicadorAlto / 2),
          ),
        );
      }),
    );
  }
}
