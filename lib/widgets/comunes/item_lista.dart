import 'package:flutter/material.dart';

import '../../utils/app_sizes.dart';
import 'app_tarjeta.dart';

/// Fila de lista en una tarjeta: ícono en cuadro de color + título +
/// subtítulo + contenido opcional a la derecha. Base para historiales,
/// notificaciones, premios, etc.
class ItemLista extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String titulo;
  final String subtitulo;
  final Widget? extremo;
  final VoidCallback? onTap;

  const ItemLista({
    super.key,
    required this.icono,
    required this.color,
    required this.titulo,
    required this.subtitulo,
    this.extremo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: AppTarjeta(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(icono, color: color, size: AppSizes.iconMd),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: textos.titleSmall),
                  const SizedBox(height: AppSizes.xs / 2),
                  Text(subtitulo, style: textos.bodySmall),
                ],
              ),
            ),
            if (extremo != null) ...[
              const SizedBox(width: AppSizes.sm),
              extremo!,
            ],
          ],
        ),
      ),
    );
  }
}
