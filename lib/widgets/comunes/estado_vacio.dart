import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Mensaje centrado con ícono para listas vacías, errores de carga o
/// secciones que aún no existen.
class EstadoVacio extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String mensaje;
  final Widget? accion;

  const EstadoVacio({
    super.key,
    required this.icono,
    required this.titulo,
    required this.mensaje,
    this.accion,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: AppSizes.iconXl, color: AppColors.borderVariant),
          const SizedBox(height: AppSizes.md),
          Text(titulo, style: textos.titleSmall, textAlign: TextAlign.center),
          const SizedBox(height: AppSizes.xs),
          Text(mensaje, style: textos.bodyMedium, textAlign: TextAlign.center),
          if (accion != null) ...[const SizedBox(height: AppSizes.md), accion!],
        ],
      ),
    );
  }
}
