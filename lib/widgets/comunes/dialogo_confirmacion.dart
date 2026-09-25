import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';

/// Pregunta al usuario antes de una acción importante (canjear, eliminar…).
/// Devuelve `true` solo si pulsa [textoConfirmar].
Future<bool> mostrarDialogoConfirmacion(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String textoConfirmar = AppStrings.confirmar,
  String textoCancelar = AppStrings.cancelar,
}) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (contextoDialogo) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(contextoDialogo, false),
          child: Text(textoCancelar),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          onPressed: () => Navigator.pop(contextoDialogo, true),
          child: Text(textoConfirmar),
        ),
      ],
    ),
  );

  return confirmado ?? false;
}
