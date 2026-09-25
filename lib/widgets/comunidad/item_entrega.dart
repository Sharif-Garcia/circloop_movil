import 'package:flutter/material.dart';

import '../../models/entrega.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_materiales.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../comunes/item_lista.dart';

/// Una entrega de material en una lista (actividad reciente, historial).
class ItemEntrega extends StatelessWidget {
  final Entrega entrega;

  const ItemEntrega({super.key, required this.entrega});

  @override
  Widget build(BuildContext context) {
    final material = AppMaterial.porClave(entrega.material);

    return ItemLista(
      icono: material.icono,
      color: material.color,
      titulo: material.nombre,
      subtitulo:
          '${Formatos.fechaRelativa(entrega.fecha)} • '
          '${Formatos.kilos(entrega.pesoKg)}',
      extremo: Text(
        AppStrings.puntosGanados(entrega.puntos),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.textSm,
        ),
      ),
    );
  }
}
