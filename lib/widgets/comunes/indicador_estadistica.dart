import 'package:flutter/material.dart';

import '../../utils/app_sizes.dart';

/// Ícono + valor destacado + descripción (por ejemplo "14,5 kg —
/// Materiales Reciclados").
class IndicadorEstadistica extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String valor;
  final String descripcion;

  const IndicadorEstadistica({
    super.key,
    required this.icono,
    required this.color,
    required this.valor,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icono, color: color, size: AppSizes.iconLg),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(valor, style: textos.titleSmall),
              Text(
                descripcion,
                style: textos.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
