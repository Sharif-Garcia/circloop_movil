import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import 'package:circloop_movil/widgets/comunes/app_logo.dart';

/// Logo dentro de un círculo + título + subtítulo. Encabezado de las
/// pantallas de autenticación (login, recuperar contraseña, registro).
class EncabezadoAuth extends StatelessWidget {
  final String titulo;
  final String subtitulo;

  const EncabezadoAuth({
    super.key,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const AppLogo(altura: AppSizes.logoMd),
        ),
        const SizedBox(height: AppSizes.md),
        Text(titulo, style: textos.headlineMedium),
        const SizedBox(height: AppSizes.xs),
        Text(subtitulo, style: textos.bodyMedium, textAlign: TextAlign.center),
      ],
    );
  }
}
