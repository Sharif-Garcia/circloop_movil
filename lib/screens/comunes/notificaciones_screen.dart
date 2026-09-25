import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notificacion.dart';
import '../../providers/notificaciones_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_tipos_notificacion.dart';
import '../../utils/formatos.dart';
import '../../widgets/botones/boton_volver.dart';
import '../../widgets/comunes/encabezado_seccion.dart';
import '../../widgets/comunes/estado_vacio.dart';
import '../../widgets/comunes/item_lista.dart';
import '../../widgets/comunes/titulo_seccion.dart';

/// Notificaciones del usuario en sesión (cualquier rol). Al tocar una se
/// marca como leída.
class NotificacionesScreen extends ConsumerWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificaciones = ref.watch(notificacionesProvider);
    final noLeidas = ref.watch(notificacionesNoLeidasProvider);
    final acciones = ref.read(notificacionesProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(notificacionesProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.lg),
            children: [
              const BotonVolver(),
              const SizedBox(height: AppSizes.md),
              const EncabezadoSeccion(
                titulo: AppStrings.notificaciones,
                subtitulo: AppStrings.subtituloNotificaciones,
              ),
              const SizedBox(height: AppSizes.lg),
              ...notificaciones.when(
                data: (lista) => lista.isEmpty
                    ? [
                        const EstadoVacio(
                          icono: Icons.notifications_none_rounded,
                          titulo: AppStrings.sinNotificaciones,
                          mensaje: AppStrings.sinNotificacionesMensaje,
                        ),
                      ]
                    : [
                        TituloSeccion(
                          titulo: AppStrings.noLeidas(noLeidas),
                          accion: noLeidas > 0
                              ? AppStrings.marcarTodasLeidas
                              : null,
                          onAccion: acciones.marcarTodasLeidas,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        for (final notificacion in lista)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _ItemNotificacion(
                              notificacion: notificacion,
                              onTap: () => acciones.marcarLeida(notificacion),
                            ),
                          ),
                      ],
                loading: () => [
                  const Center(child: CircularProgressIndicator()),
                ],
                error: (_, _) => [
                  const EstadoVacio(
                    icono: Icons.cloud_off_outlined,
                    titulo: AppStrings.errorCargar,
                    mensaje: AppStrings.errorGeneral,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemNotificacion extends StatelessWidget {
  final Notificacion notificacion;
  final VoidCallback onTap;

  const _ItemNotificacion({required this.notificacion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tipo = AppTipoNotificacion.porClave(notificacion.tipo);

    return ItemLista(
      icono: tipo.icono,
      color: tipo.color,
      titulo: notificacion.titulo,
      subtitulo:
          '${notificacion.mensaje}\n'
          '${Formatos.fechaRelativa(notificacion.fecha)}',
      // Punto verde = sin leer
      extremo: notificacion.leida
          ? null
          : Container(
              key: const ValueKey('sin-leer'),
              width: AppSizes.indicadorAlto,
              height: AppSizes.indicadorAlto,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
      onTap: onTap,
    );
  }
}
