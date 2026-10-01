import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Imagen local de la marca (assets/images/: logo, mascota, GIF del
/// onboarding) con un ícono de respaldo si el archivo todavía no existe. Las
/// imágenes que vienen de la base de datos (premios, fotos de usuario…) usan
/// `ImagenRemota`.
class AppImagen extends StatelessWidget {
  final String ruta;
  final double altura;
  final double? ancho;
  final BoxFit? ajuste;
  final IconData iconoRespaldo;
  final Color colorRespaldo;

  const AppImagen({
    super.key,
    required this.ruta,
    required this.altura,
    this.ancho,
    this.ajuste,
    this.iconoRespaldo = Icons.image_outlined,
    this.colorRespaldo = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    // Los GIF se animan solos con Image.asset
    return Image.asset(
      ruta,
      height: altura,
      width: ancho,
      fit: ajuste,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        final icono = Icon(
          iconoRespaldo,
          size: altura * 0.7,
          color: colorRespaldo,
        );
        // Con ancho fijo, el respaldo ocupa el mismo espacio que la imagen
        if (ancho == null) return icono;
        return SizedBox(
          width: ancho,
          height: altura,
          child: Center(child: icono),
        );
      },
    );
  }
}
