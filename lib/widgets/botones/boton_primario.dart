import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Botón principal de ancho completo. El color, alto, bordes y texto
/// los hereda de `filledButtonTheme` en AppTheme.
class BotonPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final bool cargando;

  const BotonPrimario({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cargando = false,
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
          : Text(texto),
    );
  }
}
