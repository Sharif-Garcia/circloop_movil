import 'package:flutter/material.dart';

class OnboardingPaso {
  final String titulo;
  final String descripcion;

  /// Tema del paso, se muestra junto a "Paso X de Y".
  final String etiqueta;

  /// GIF animado del paso (`AppImages`).
  final String imagen;

  /// Ícono de respaldo si el GIF aún no existe, y color de acento del paso.
  final IconData icono;
  final Color color;

  /// Íconos pequeños que flotan alrededor de la ilustración.
  final List<IconData> iconosSecundarios;

  const OnboardingPaso({
    required this.titulo,
    required this.descripcion,
    required this.etiqueta,
    required this.imagen,
    required this.icono,
    required this.color,
    this.iconosSecundarios = const [],
  });
}
