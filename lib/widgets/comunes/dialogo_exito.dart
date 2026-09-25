import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Muestra un diálogo de confirmación con un único botón. El usuario no
/// puede cerrarlo tocando fuera; al pulsar el botón se cierra y se
/// ejecuta [alAceptar].
Future<void> mostrarDialogoExito(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  required String textoBoton,
  VoidCallback? alAceptar,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (contextoDialogo) => AlertDialog(
      icon: const Icon(Icons.check_circle, color: AppColors.success),
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          onPressed: () {
            Navigator.pop(contextoDialogo);
            alAceptar?.call();
          },
          child: Text(textoBoton),
        ),
      ],
    ),
  );
}
