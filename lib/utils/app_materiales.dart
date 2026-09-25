import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Apariencia de cada tipo de material reciclable. Las claves coinciden con
/// `Entrega.material` en assets/data/entregas.json.
class AppMaterial {
  final String nombre;

  /// Nombre de una palabra para filtros y espacios reducidos.
  final String nombreCorto;
  final IconData icono;
  final Color color;

  const AppMaterial({
    required this.nombre,
    required this.nombreCorto,
    required this.icono,
    required this.color,
  });

  static const Map<String, AppMaterial> _materiales = {
    'plastico': AppMaterial(
      nombre: 'Plástico PET',
      nombreCorto: 'Plástico',
      icono: Icons.local_drink_outlined,
      color: AppColors.secondary,
    ),
    'papel': AppMaterial(
      nombre: 'Papel/Cartón',
      nombreCorto: 'Papel',
      icono: Icons.description_outlined,
      color: AppColors.tertiary,
    ),
    'vidrio': AppMaterial(
      nombre: 'Vidrio',
      nombreCorto: 'Vidrio',
      icono: Icons.wine_bar_outlined,
      color: AppColors.success,
    ),
    'aluminio': AppMaterial(
      nombre: 'Latas de Aluminio',
      nombreCorto: 'Metal',
      icono: Icons.recycling,
      color: AppColors.greyDark,
    ),
    'organico': AppMaterial(
      nombre: 'Residuos Orgánicos',
      nombreCorto: 'Orgánico',
      icono: Icons.compost_outlined,
      color: AppColors.primaryDark,
    ),
  };

  static const AppMaterial _otro = AppMaterial(
    nombre: 'Material reciclable',
    nombreCorto: 'Otro',
    icono: Icons.autorenew,
    color: AppColors.primary,
  );

  /// Claves de todos los materiales, en el orden en que se muestran.
  static List<String> get claves => _materiales.keys.toList();

  static AppMaterial porClave(String clave) => _materiales[clave] ?? _otro;
}
