import 'package:flutter/material.dart';

import '../../models/nivel_eco.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../comunes/app_tarjeta.dart';
import '../comunes/etiqueta.dart';

/// Nivel actual del usuario, su XP y la barra de avance al siguiente nivel.
class TarjetaNivel extends StatelessWidget {
  /// Puntos históricos del usuario.
  final int xp;

  const TarjetaNivel({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final nivel = NivelEco.paraXp(xp);
    final siguiente = nivel.siguiente;
    final progreso = nivel.progreso(xp);

    return AppTarjeta(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                child: Etiqueta(
                  texto: AppStrings.nivel(nivel.numero, nivel.nombre),
                  icono: Icons.verified_rounded,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              if (siguiente != null)
                Text(
                  AppStrings.progresoXp(
                    Formatos.entero(xp),
                    Formatos.entero(siguiente.xpMinima),
                  ),
                  style: textos.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: AppSizes.indicadorAlto,
              backgroundColor: AppColors.greyLight,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            siguiente == null
                ? AppStrings.nivelMaximo
                : AppStrings.progresoNivel(
                    (progreso * 100).floor(),
                    siguiente.numero,
                    siguiente.nombre,
                  ),
            style: textos.bodySmall,
          ),
        ],
      ),
    );
  }
}
