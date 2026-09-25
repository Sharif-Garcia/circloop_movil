import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Botón de acción rápida: tarjeta con ícono grande, título y subtítulo,
/// teñida con [color]. Pensado para usarse en fila (con `Expanded`) en el
/// inicio de cualquier rol.
class BotonAccion extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color color;
  final VoidCallback? onPressed;

  const BotonAccion({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.onPressed,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final radio = BorderRadius.circular(AppSizes.radiusLg);

    return Material(
      color: color.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: radio,
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: radio,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.md,
            horizontal: AppSizes.xs,
          ),
          child: Column(
            children: [
              Icon(icono, size: AppSizes.iconLg, color: color),
              const SizedBox(height: AppSizes.sm),
              Text(
                titulo,
                style: textos.titleSmall?.copyWith(color: color),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitulo,
                style: textos.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
