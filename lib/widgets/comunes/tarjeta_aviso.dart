import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Recuadro teñido con ícono, título y líneas de texto (instrucciones,
/// consejos, avisos).
class TarjetaAviso extends StatelessWidget {
  final String titulo;
  final List<String> lineas;
  final IconData icono;
  final Color color;

  const TarjetaAviso({
    super.key,
    required this.titulo,
    required this.lineas,
    this.icono = Icons.info_outline,
    this.color = AppColors.success,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: AppSizes.iconMd),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  titulo,
                  style: textos.titleSmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
          for (final linea in lineas) ...[
            const SizedBox(height: AppSizes.sm),
            Text(
              linea,
              style: textos.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
