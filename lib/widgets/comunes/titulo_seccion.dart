import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Título de un bloque dentro de una pantalla, con un enlace opcional a la
/// derecha (por ejemplo "Actividad Reciente ····· Ver Historial").
class TituloSeccion extends StatelessWidget {
  final String titulo;
  final String? accion;
  final VoidCallback? onAccion;

  const TituloSeccion({
    super.key,
    required this.titulo,
    this.accion,
    this.onAccion,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(titulo, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (accion != null)
          TextButton(
            onPressed: onAccion,
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Text(accion!),
          ),
      ],
    );
  }
}
