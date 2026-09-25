import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Botón de ancho completo con borde (acciones secundarias como "Editar
/// Perfil"). Con [color] se tiñe borde, texto y fondo, por ejemplo
/// `AppColors.error` para "Cerrar Sesión".
class BotonSecundario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icono;
  final Color color;

  const BotonSecundario({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final estilo = OutlinedButton.styleFrom(
      foregroundColor: color,
      backgroundColor: color.withValues(alpha: 0.06),
      side: BorderSide(color: color.withValues(alpha: 0.5)),
    );

    if (icono == null) {
      return OutlinedButton(
        onPressed: onPressed,
        style: estilo,
        child: Text(texto),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: estilo,
      icon: Icon(icono),
      label: Text(texto),
    );
  }
}
