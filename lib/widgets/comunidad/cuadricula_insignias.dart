import 'package:flutter/material.dart';

import '../../models/insignia.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_iconos.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';

/// Insignias en cuadrícula de 3 columnas. Las no ganadas se ven grises con
/// candado. Al tocar una se muestra cómo ganarla.
class CuadriculaInsignias extends StatelessWidget {
  final List<({Insignia insignia, bool lograda})> insignias;

  const CuadriculaInsignias({super.key, required this.insignias});

  static const int _columnas = 3;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _columnas,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSizes.sm,
      mainAxisSpacing: AppSizes.sm,
      children: [
        for (final item in insignias)
          _ItemInsignia(insignia: item.insignia, lograda: item.lograda),
      ],
    );
  }
}

class _ItemInsignia extends StatelessWidget {
  final Insignia insignia;
  final bool lograda;

  const _ItemInsignia({required this.insignia, required this.lograda});

  @override
  Widget build(BuildContext context) {
    final color = lograda ? AppColors.success : AppColors.grey;
    final radio = BorderRadius.circular(AppSizes.radiusMd);

    return Tooltip(
      message: lograda
          ? insignia.descripcion
          : '${AppStrings.insigniaBloqueada}: ${insignia.descripcion}',
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.xs),
        decoration: BoxDecoration(
          color: lograda
              ? AppColors.success.withValues(alpha: 0.06)
              : AppColors.greyLight,
          borderRadius: radio,
          border: Border.all(
            color: lograda
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              lograda
                  ? AppIconos.porNombre(insignia.icono)
                  : Icons.lock_outline,
              size: AppSizes.iconLg,
              color: color,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              insignia.nombre,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: lograda ? AppColors.textPrimary : AppColors.grey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
