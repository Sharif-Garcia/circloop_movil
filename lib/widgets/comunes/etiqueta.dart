import 'package:flutter/material.dart';

import '../../utils/app_sizes.dart';

/// Pastilla de color con ícono y texto (puntos, nivel, estado…).
class Etiqueta extends StatelessWidget {
  final String texto;
  final Color color;
  final IconData? icono;

  const Etiqueta({
    super.key,
    required this.texto,
    required this.color,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: AppSizes.iconSm, color: color),
            const SizedBox(width: AppSizes.xs),
          ],
          Flexible(
            child: Text(
              texto,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
