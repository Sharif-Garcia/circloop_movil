import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Imagen que viene de la base de datos (URL). Mientras carga muestra un
/// indicador, y si no hay URL o falla la descarga (sin conexión, imagen
/// borrada) muestra un ícono de respaldo. Para imágenes locales de la
/// marca se usa `AppImagen`.
class ImagenRemota extends StatelessWidget {
  final String? url;
  final double altura;
  final IconData iconoRespaldo;
  final Color colorRespaldo;

  /// Si es `true`, ocupa todo el ancho y recorta la imagen para llenarlo.
  final bool llenarAncho;

  const ImagenRemota({
    super.key,
    required this.url,
    required this.altura,
    this.iconoRespaldo = Icons.image_outlined,
    this.colorRespaldo = AppColors.primary,
    this.llenarAncho = false,
  });

  @override
  Widget build(BuildContext context) {
    final respaldo = SizedBox(
      height: altura,
      width: llenarAncho ? double.infinity : null,
      child: Icon(iconoRespaldo, size: altura * 0.4, color: colorRespaldo),
    );

    if (url == null || url!.isEmpty) return respaldo;

    return Image.network(
      url!,
      height: altura,
      width: llenarAncho ? double.infinity : null,
      fit: llenarAncho ? BoxFit.cover : null,
      loadingBuilder: (context, imagen, progreso) {
        if (progreso == null) return imagen;
        return SizedBox(
          height: altura,
          width: llenarAncho ? double.infinity : null,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorRespaldo,
              value: progreso.expectedTotalBytes == null
                  ? null
                  : progreso.cumulativeBytesLoaded /
                        progreso.expectedTotalBytes!,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => respaldo,
    );
  }
}
