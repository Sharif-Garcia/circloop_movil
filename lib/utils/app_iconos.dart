import 'package:flutter/material.dart';

/// Íconos referenciados por nombre desde los JSON de `assets/data/`
/// (por ejemplo, el campo "icono" de insignias.json).
class AppIconos {
  static const Map<String, IconData> _iconos = {
    'verified': Icons.verified_rounded,
    'bolt': Icons.bolt_rounded,
    'eco': Icons.eco_rounded,
    'wine_bar': Icons.wine_bar_rounded,
    'school': Icons.school_rounded,
    'recycling': Icons.recycling_rounded,
    'star': Icons.star_rounded,
    'emoji_events': Icons.emoji_events_rounded,
  };

  static IconData porNombre(String nombre) =>
      _iconos[nombre] ?? Icons.workspace_premium_rounded;
}
