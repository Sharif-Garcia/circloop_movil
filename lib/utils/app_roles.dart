import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Apariencia de cada rol en la interfaz. Los ids coinciden con
/// assets/data/roles.json (Usuario.rolId).
class AppRol {
  final String nombre;
  final String tituloPanel;
  final IconData icono;
  final Color color;

  const AppRol({
    required this.nombre,
    required this.tituloPanel,
    required this.icono,
    required this.color,
  });

  static const int comunidad = 1;
  static const int operador = 2;
  static const int puntoCanje = 3;
  static const int administrador = 4;

  static const Map<int, AppRol> _roles = {
    comunidad: AppRol(
      nombre: 'Comunidad',
      tituloPanel: 'Panel de Comunidad',
      icono: Icons.school,
      color: AppColors.primary,
    ),
    operador: AppRol(
      nombre: 'Operador',
      tituloPanel: 'Panel de Operador',
      icono: Icons.engineering,
      color: AppColors.secondary,
    ),
    puntoCanje: AppRol(
      nombre: 'Punto de canje',
      tituloPanel: 'Panel de Punto de Canje',
      icono: Icons.store,
      color: AppColors.tertiary,
    ),
    administrador: AppRol(
      nombre: 'Administrador',
      tituloPanel: 'Panel de Administrador',
      icono: Icons.admin_panel_settings,
      color: AppColors.primaryDark,
    ),
  };

  static const AppRol _desconocido = AppRol(
    nombre: 'Usuario',
    tituloPanel: 'Panel',
    icono: Icons.dashboard,
    color: AppColors.primary,
  );

  static AppRol porId(int rolId) => _roles[rolId] ?? _desconocido;
}
