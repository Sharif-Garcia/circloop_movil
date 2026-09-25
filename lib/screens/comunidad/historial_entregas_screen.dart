import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/progreso_eco.dart';
import '../../providers/auth_provider.dart';
import '../../providers/entregas_provider.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../widgets/botones/boton_volver.dart';
import '../../widgets/comunes/encabezado_seccion.dart';
import '../../widgets/comunes/estado_vacio.dart';
import '../../widgets/comunidad/item_entrega.dart';
import '../../widgets/comunidad/tarjeta_impacto.dart';

/// Todas las entregas del usuario en sesión.
class HistorialEntregasScreen extends ConsumerWidget {
  const HistorialEntregasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authProvider).value;
    final entregas = ref.watch(entregasUsuarioProvider);
    if (usuario == null) return const Scaffold();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.lg),
          children: [
            const BotonVolver(),
            const SizedBox(height: AppSizes.md),
            const EncabezadoSeccion(
              titulo: AppStrings.tituloHistorial,
              subtitulo: AppStrings.subtituloHistorial,
            ),
            const SizedBox(height: AppSizes.lg),
            ...entregas.when(
              data: (lista) => lista.isEmpty
                  ? [
                      const EstadoVacio(
                        icono: Icons.recycling,
                        titulo: AppStrings.sinEntregas,
                        mensaje: AppStrings.sinEntregasMensaje,
                      ),
                    ]
                  : [
                      TarjetaImpacto(
                        progreso: ProgresoEco.desde(usuario, lista),
                      ),
                      const SizedBox(height: AppSizes.md),
                      for (final entrega in lista)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.sm),
                          child: ItemEntrega(entrega: entrega),
                        ),
                    ],
              loading: () => [const Center(child: CircularProgressIndicator())],
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
    );
  }
}
