import 'package:flutter/material.dart';

import '../../utils/app_images.dart';
import '../../utils/app_sizes.dart';
import 'package:circloop_movil/widgets/comunes/app_imagen.dart';

/// Logo de CIRCLOOP. Si la imagen aún no existe en assets/images/,
/// muestra un ícono de respaldo con el color primario.
class AppLogo extends StatelessWidget {
  final double altura;

  const AppLogo({super.key, this.altura = AppSizes.logoLg});

  @override
  Widget build(BuildContext context) {
    return AppImagen(
      ruta: AppImages.logo,
      altura: altura,
      iconoRespaldo: Icons.eco,
    );
  }
}
