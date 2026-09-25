import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import 'app_tarjeta.dart';

/// Un valor dentro de [TarjetaResumen].
class DatoResumen {
  final String valor;
  final String descripcion;

  /// Color del valor; por defecto, el del texto principal.
  final Color? color;

  const DatoResumen({
    required this.valor,
    required this.descripcion,
    this.color,
  });
}

/// Tarjeta con varios valores en fila separados por líneas (por ejemplo
/// "6 Entregas | 14,5 kg Peso Total | +230 pts Este Mes").
class TarjetaResumen extends StatelessWidget {
  final List<DatoResumen> datos;

  const TarjetaResumen({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return AppTarjeta(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.md,
        horizontal: AppSizes.sm,
      ),
      child: Row(
        children: [
          for (var i = 0; i < datos.length; i++) ...[
            if (i > 0)
              Container(
                height: AppSizes.separadorAlto,
                width: 1,
                color: AppColors.border,
              ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    datos[i].valor,
                    style: textos.titleSmall?.copyWith(color: datos[i].color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    datos[i].descripcion,
                    style: textos.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
