import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Texto con una parte pulsable, por ejemplo:
/// "¿Ya tienes cuenta? **Inicia sesión**".
class EnlaceTexto extends StatelessWidget {
  final String texto;
  final String accion;
  final VoidCallback onPressed;

  const EnlaceTexto({
    super.key,
    required this.texto,
    required this.accion,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap: si no cabe en una línea (pantalla angosta o letra grande),
    // el enlace pasa a la siguiente en lugar de salirse de la pantalla.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(texto, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(accion),
        ),
      ],
    );
  }
}
