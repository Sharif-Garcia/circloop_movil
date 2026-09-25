import 'package:flutter/material.dart';

import '../../models/usuario.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Foto del usuario en un círculo. Si no tiene foto (o no carga), muestra
/// sus iniciales.
class AvatarUsuario extends StatelessWidget {
  final Usuario usuario;
  final double diametro;

  const AvatarUsuario({
    super.key,
    required this.usuario,
    this.diametro = AppSizes.avatarSm,
  });

  String get _iniciales {
    final nombre = usuario.nombres.trim();
    final apellido = usuario.apellidos.trim();
    return [
      if (nombre.isNotEmpty) nombre[0],
      if (apellido.isNotEmpty) apellido[0],
    ].join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final foto = usuario.fotoUrl;

    return CircleAvatar(
      radius: diametro / 2,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      foregroundImage: foto != null ? NetworkImage(foto) : null,
      onForegroundImageError: foto != null ? (_, _) {} : null,
      child: Text(
        _iniciales,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: diametro * 0.38,
        ),
      ),
    );
  }
}
