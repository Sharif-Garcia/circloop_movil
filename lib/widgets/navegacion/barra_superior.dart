import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/usuario.dart';
import '../../providers/notificaciones_provider.dart';
import '../../screens/comunes/notificaciones_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../comunes/avatar_usuario.dart';
import '../comunes/etiqueta.dart';
import 'panel_navegacion.dart';

/// Barra superior de los paneles: avatar + nombre de la app a la izquierda;
/// puntos (opcional) y notificaciones a la derecha.
class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final Usuario usuario;

  /// Si se indica, muestra los puntos disponibles (rol comunidad).
  final int? puntos;

  /// Índice de la pestaña de perfil: al tocar el avatar se va a ella.
  final int? pestanaPerfil;

  const BarraSuperior({
    super.key,
    required this.usuario,
    this.puntos,
    this.pestanaPerfil,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: AppSizes.md,
      title: Row(
        children: [
          GestureDetector(
            onTap: pestanaPerfil == null
                ? null
                : () => PanelNavegacion.of(context).irA(pestanaPerfil!),
            child: AvatarUsuario(usuario: usuario),
          ),
          const SizedBox(width: AppSizes.sm),
          Flexible(
            child: Text(
              AppStrings.nombreApp,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        if (puntos != null)
          Etiqueta(
            texto: AppStrings.puntos(Formatos.entero(puntos!)),
            icono: Icons.star_rounded,
            color: AppColors.tertiary,
          ),
        const _BotonNotificaciones(),
        const SizedBox(width: AppSizes.xs),
      ],
    );
  }
}

/// Campana con el número de notificaciones sin leer; abre la lista.
class _BotonNotificaciones extends ConsumerWidget {
  const _BotonNotificaciones();

  /// A partir de este número se muestra "9+".
  static const int _maximoVisible = 9;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noLeidas = ref.watch(notificacionesNoLeidasProvider);

    return IconButton(
      tooltip: AppStrings.notificaciones,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificacionesScreen()),
      ),
      icon: Badge(
        isLabelVisible: noLeidas > 0,
        label: Text(
          noLeidas > _maximoVisible ? '$_maximoVisible+' : '$noLeidas',
        ),
        child: Icon(
          noLeidas > 0
              ? Icons.notifications_rounded
              : Icons.notifications_none_rounded,
        ),
      ),
    );
  }
}
