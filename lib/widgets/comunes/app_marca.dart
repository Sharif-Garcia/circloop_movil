import 'package:flutter/material.dart';

import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import 'package:circloop_movil/widgets/comunes/app_logo.dart';

/// Logo pequeño + nombre de la app en fila. Se usa en encabezados.
class AppMarca extends StatelessWidget {
  const AppMarca({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppLogo(altura: AppSizes.logoSm),
        const SizedBox(width: AppSizes.sm),
        Text(
          AppStrings.nombreApp,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
