import 'package:flutter/material.dart';

import '../../models/usuario.dart';
import '../../utils/app_sizes.dart';
import 'app_tarjeta.dart';
import 'avatar_usuario.dart';

/// Tarjeta de encabezado del perfil: avatar, nombre completo, correo, un
/// dato adicional opcional (por ejemplo la carrera) y una etiqueta (nivel
/// o rol).
class TarjetaPerfil extends StatelessWidget {
  final Usuario usuario;
  final String? detalle;
  final Widget? etiqueta;

  const TarjetaPerfil({
    super.key,
    required this.usuario,
    this.detalle,
    this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return AppTarjeta(
      child: Column(
        children: [
          AvatarUsuario(usuario: usuario, diametro: AppSizes.avatarLg),
          const SizedBox(height: AppSizes.md),
          Text(
            '${usuario.nombres} ${usuario.apellidos}',
            style: textos.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            usuario.correoInstitucional,
            style: textos.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (detalle != null)
            Text(
              detalle!,
              style: textos.bodySmall,
              textAlign: TextAlign.center,
            ),
          if (etiqueta != null) ...[
            const SizedBox(height: AppSizes.md),
            etiqueta!,
          ],
        ],
      ),
    );
  }
}
