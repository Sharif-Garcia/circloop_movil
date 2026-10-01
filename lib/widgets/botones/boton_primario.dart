import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Botón principal de ancho completo. El color, alto, bordes y texto
/// los hereda de `filledButtonTheme` en AppTheme. `iconoFinal` pone un ícono
/// después del texto (por ejemplo una flecha en "Siguiente").
class BotonPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final bool cargando;
  final IconData? iconoFinal;

  const BotonPrimario({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cargando = false,
    this.iconoFinal,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: cargando ? null : onPressed,
      child: cargando
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
          : iconoFinal == null
          ? Text(texto)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(texto),
                const SizedBox(width: AppSizes.sm),
                Icon(iconoFinal, size: AppSizes.iconSm),
              ],
            ),
    );
  }
}
