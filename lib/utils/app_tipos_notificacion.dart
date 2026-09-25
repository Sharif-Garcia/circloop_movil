import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Apariencia de cada tipo de notificación. Las claves coinciden con
/// `Notificacion.tipo` en assets/data/notificaciones.json.
class AppTipoNotificacion {
  static const String entrega = 'entrega';
  static const String canje = 'canje';
  static const String transferencia = 'transferencia';
  static const String insignia = 'insignia';
  static const String sistema = 'sistema';

  final IconData icono;
  final Color color;

  const AppTipoNotificacion({required this.icono, required this.color});

  static const Map<String, AppTipoNotificacion> _tipos = {
    entrega: AppTipoNotificacion(
      icono: Icons.recycling,
      color: AppColors.success,
    ),
    canje: AppTipoNotificacion(
      icono: Icons.card_giftcard_outlined,
      color: AppColors.tertiary,
    ),
    transferencia: AppTipoNotificacion(
      icono: Icons.send_outlined,
      color: AppColors.secondary,
    ),
    insignia: AppTipoNotificacion(
      icono: Icons.workspace_premium_outlined,
      color: AppColors.primary,
    ),
    sistema: AppTipoNotificacion(
      icono: Icons.campaign_outlined,
      color: AppColors.greyDark,
    ),
  };

  static AppTipoNotificacion porClave(String clave) =>
      _tipos[clave] ?? _tipos[sistema]!;
}
