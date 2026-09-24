import 'package:flutter/material.dart';

import '../../utils/app_sizes.dart';

/// Título + subtítulo alineados a la izquierda, al inicio de una pantalla.
class EncabezadoSeccion extends StatelessWidget {
  final String titulo;
  final String subtitulo;

  const EncabezadoSeccion({
    super.key,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: textos.headlineSmall),
        const SizedBox(height: AppSizes.xs),
        Text(subtitulo, style: textos.bodyMedium),
      ],
    );
  }
}
