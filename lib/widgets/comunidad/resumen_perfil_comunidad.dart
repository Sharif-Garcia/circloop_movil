import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/progreso_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../comunes/tarjeta_dato.dart';
import '../comunes/titulo_seccion.dart';
import 'cuadricula_insignias.dart';

/// Parte del perfil exclusiva del rol comunidad: puntos, kg reciclados,
/// puesto en el ranking e insignias.
class ResumenPerfilComunidad extends ConsumerWidget {
  const ResumenPerfilComunidad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authProvider).value;
    if (usuario == null) return const SizedBox.shrink();

    final progreso = ref.watch(progresoUsuarioProvider).value;
    final puesto = ref.watch(puestoRankingProvider).value;
    final insignias = ref.watch(insigniasUsuarioProvider).value ?? const [];
    final logradas = insignias.where((item) => item.lograda).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TarjetaDato(
                icono: Icons.star_rounded,
                color: AppColors.tertiary,
                valor: Formatos.entero(usuario.puntosTotales),
                descripcion: AppStrings.puntosDisponibles,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: TarjetaDato(
                icono: Icons.scale_outlined,
                color: AppColors.success,
                valor: Formatos.kilos(progreso?.pesoKg ?? 0),
                descripcion: AppStrings.kgReciclados,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: TarjetaDato(
                icono: Icons.emoji_events_outlined,
                color: AppColors.secondary,
                valor: puesto != null
                    ? AppStrings.puesto(puesto)
                    : AppStrings.sinPuesto,
                descripcion: AppStrings.puestoRanking,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        TituloSeccion(
          titulo: AppStrings.insigniasLogradas(logradas, insignias.length),
        ),
        const SizedBox(height: AppSizes.sm),
        CuadriculaInsignias(insignias: insignias),
      ],
    );
  }
}
