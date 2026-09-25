import 'package:flutter/material.dart';

import '../../utils/app_strings.dart';
import '../../widgets/comunes/estado_vacio.dart';

/// Contenido provisional para pestañas o secciones que aún no existen.
class EnConstruccionScreen extends StatelessWidget {
  final String titulo;
  final IconData icono;

  const EnConstruccionScreen({
    super.key,
    required this.titulo,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EstadoVacio(
        icono: icono,
        titulo: titulo,
        mensaje: AppStrings.enConstruccion,
      ),
    );
  }
}
