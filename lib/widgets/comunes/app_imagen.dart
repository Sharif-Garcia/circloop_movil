import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Imagen de assets/images/ con un ícono de respaldo si el archivo
/// todavía no existe o no se puede cargar.
class AppImagen extends StatelessWidget {
  final String ruta;
  final double altura;
  final IconData iconoRespaldo;

  const AppImagen({
    super.key,
    required this.ruta,
    required this.altura,
    this.iconoRespaldo = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ruta,
      height: altura,
      errorBuilder: (context, error, stackTrace) => Icon(
        iconoRespaldo,
        size: altura * 0.7,
        color: AppColors.primary,
      ),
    );
  }
}
