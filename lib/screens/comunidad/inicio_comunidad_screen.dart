import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/entrega.dart';
import '../../models/progreso_eco.dart';
import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../providers/carreras_provider.dart';
import '../../providers/entregas_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../widgets/botones/boton_accion.dart';
import '../../widgets/comunes/app_imagen.dart';
import '../../widgets/comunes/estado_vacio.dart';
import '../../widgets/comunes/titulo_seccion.dart';
import '../../widgets/comunidad/item_entrega.dart';
import '../../widgets/comunidad/tarjeta_impacto.dart';
import '../../widgets/comunidad/tarjeta_nivel.dart';
import '../../widgets/navegacion/panel_navegacion.dart';
import 'historial_entregas_screen.dart';
import 'panel_comunidad_screen.dart';

/// Pestaña "Inicio" del rol comunidad: saludo, nivel, acciones rápidas,
/// impacto ambiental y actividad reciente.
class InicioComunidadScreen extends ConsumerWidget {
  const InicioComunidadScreen({super.key});

  /// Cantidad de entregas que se muestran en "Actividad Reciente".
  static const int _entregasRecientes = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authProvider).value;
    if (usuario == null) return const SizedBox.shrink();

    final textos = Theme.of(context).textTheme;
    final carrera = ref.watch(carreraUsuarioProvider).value;
    final entregas = ref.watch(entregasUsuarioProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(entregasUsuarioProvider.future),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Saludo
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.saludo(usuario.nombres),
                        style: textos.headlineSmall,
                      ),
                      if (carrera != null) ...[
                        const SizedBox(height: AppSizes.xs),
                        Text(carrera.nombre, style: textos.bodyMedium),
                      ],
                    ],
                  ),
                ),
                const AppImagen(
                  ruta: AppImages.mascota,
                  altura: AppSizes.mascotaSm,
                  iconoRespaldo: Icons.smart_toy_outlined,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            TarjetaNivel(xp: usuario.puntosHistoricos),
            const SizedBox(height: AppSizes.md),

            _accionesRapidas(context),
            const SizedBox(height: AppSizes.md),

            entregas.when(
              data: (lista) => _impactoYActividad(context, usuario, lista),
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSizes.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const EstadoVacio(
                icono: Icons.cloud_off_outlined,
                titulo: AppStrings.errorCargar,
                mensaje: AppStrings.errorGeneral,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accionesRapidas(BuildContext context) {
    void irA(int pestana) => PanelNavegacion.of(context).irA(pestana);

    return Row(
      children: [
        Expanded(
          child: BotonAccion(
            titulo: AppStrings.reciclar,
            subtitulo: AppStrings.escanearQr,
            icono: Icons.qr_code_scanner,
            onPressed: () => irA(PestanaComunidad.reciclaje),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: BotonAccion(
            titulo: AppStrings.canjear,
            subtitulo: AppStrings.misPremios,
            icono: Icons.card_giftcard,
            color: AppColors.tertiary,
            onPressed: () => irA(PestanaComunidad.canjes),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: BotonAccion(
            titulo: AppStrings.ranking,
            subtitulo: AppStrings.topCampus,
            icono: Icons.emoji_events_outlined,
            color: AppColors.secondary,
            onPressed: () => irA(PestanaComunidad.experiencia),
          ),
        ),
      ],
    );
  }

  Widget _impactoYActividad(
    BuildContext context,
    Usuario usuario,
    List<Entrega> entregas,
  ) {
    if (entregas.isEmpty) {
      return const EstadoVacio(
        icono: Icons.recycling,
        titulo: AppStrings.sinEntregas,
        mensaje: AppStrings.sinEntregasMensaje,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TarjetaImpacto(progreso: ProgresoEco.desde(usuario, entregas)),
        const SizedBox(height: AppSizes.lg),
        TituloSeccion(
          titulo: AppStrings.actividadReciente,
          accion: AppStrings.verHistorial,
          onAccion: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HistorialEntregasScreen(),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        for (final entrega in entregas.take(_entregasRecientes))
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: ItemEntrega(entrega: entrega),
          ),
      ],
    );
  }
}
