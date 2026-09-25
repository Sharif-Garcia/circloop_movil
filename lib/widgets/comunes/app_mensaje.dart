import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Mensajes flotantes (SnackBar) con el color según su tipo.
class AppMensaje {
  static void exito(BuildContext context, String texto) =>
      _mostrar(context, texto, AppColors.success);

  static void error(BuildContext context, String texto) =>
      _mostrar(context, texto, AppColors.error);

  static void aviso(BuildContext context, String texto) =>
      _mostrar(context, texto, AppColors.warning);

  static void info(BuildContext context, String texto) =>
      _mostrar(context, texto, AppColors.info);

  static void _mostrar(BuildContext context, String texto, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto), backgroundColor: color));
  }
}
