import 'package:flutter/material.dart';

import '../../utils/app_sizes.dart';
import 'app_tarjeta.dart';

/// Tarjeta pequeña con un dato destacado: ícono, valor y descripción, en
/// vertical. Pensada para usarse en fila (con `Expanded`) en perfiles y
/// paneles de resumen de cualquier rol.
class TarjetaDato extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String valor;
  final String descripcion;

  const TarjetaDato({
    super.key,
    required this.icono,
    required this.color,
    required this.valor,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return AppTarjeta(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.md,
        horizontal: AppSizes.xs,
      ),
      child: Column(
        children: [
          Icon(icono, size: AppSizes.iconMd, color: color),
          const SizedBox(height: AppSizes.xs),
          Text(
            valor,
            style: textos.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            descripcion,
            style: textos.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
