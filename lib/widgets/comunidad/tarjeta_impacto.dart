import 'package:flutter/material.dart';

import '../../models/progreso_eco.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../comunes/app_tarjeta.dart';
import '../comunes/indicador_estadistica.dart';

/// Impacto ambiental acumulado del usuario: kilos reciclados y CO₂ evitado.
class TarjetaImpacto extends StatelessWidget {
  final ProgresoEco progreso;

  const TarjetaImpacto({super.key, required this.progreso});

  @override
  Widget build(BuildContext context) {
    return AppTarjeta(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Expanded(
            child: IndicadorEstadistica(
              icono: Icons.eco,
              color: AppColors.success,
              valor: Formatos.kilos(progreso.pesoKg),
              descripcion: AppStrings.materialesReciclados,
            ),
          ),
          Container(
            height: AppSizes.separadorAlto,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
            color: AppColors.border,
          ),
          Expanded(
            child: IndicadorEstadistica(
              icono: Icons.cloud_outlined,
              color: AppColors.secondary,
              valor: '${Formatos.kilos(progreso.co2EvitadoKg)} CO₂',
              descripcion: AppStrings.emisionesEvitadas,
            ),
          ),
        ],
      ),
    );
  }
}
