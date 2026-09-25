import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Apariencia de cada categoría del catálogo de premios. Las claves
/// coinciden con `Premio.categoria` en assets/data/premios.json.
class AppCategoriaPremio {
  final String nombre;
  final IconData icono;
  final Color color;

  const AppCategoriaPremio({
    required this.nombre,
    required this.icono,
    required this.color,
  });

  static const Map<String, AppCategoriaPremio> _categorias = {
    'comida': AppCategoriaPremio(
      nombre: 'Comida',
      icono: Icons.restaurant_outlined,
      color: AppColors.tertiary,
    ),
    'merchandise': AppCategoriaPremio(
      nombre: 'Merchandise',
      icono: Icons.shopping_bag_outlined,
      color: AppColors.secondary,
    ),
    'experiencias': AppCategoriaPremio(
      nombre: 'Experiencias',
      icono: Icons.local_activity_outlined,
      color: AppColors.primary,
    ),
  };

  static const AppCategoriaPremio _otra = AppCategoriaPremio(
    nombre: 'Otros',
    icono: Icons.card_giftcard_outlined,
    color: AppColors.primary,
  );

  /// Claves de todas las categorías, en el orden en que se muestran.
  static List<String> get claves => _categorias.keys.toList();

  static AppCategoriaPremio porClave(String clave) =>
      _categorias[clave] ?? _otra;
}
