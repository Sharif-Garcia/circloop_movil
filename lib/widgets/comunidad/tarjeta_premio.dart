import 'package:flutter/material.dart';

import '../../models/premio.dart';
import '../../utils/app_categorias_premio.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../botones/boton_primario.dart';
import '../comunes/imagen_remota.dart';
import '../comunes/app_tarjeta.dart';
import '../comunes/etiqueta.dart';

/// Premio del catálogo: imagen de la base de datos (o ícono de su
/// categoría), establecimiento, nombre, costo, stock y botón "Canjear".
/// Si está agotado o no alcanzan los puntos, el botón se desactiva y dice
/// por qué.
class TarjetaPremio extends StatelessWidget {
  final Premio premio;
  final int puntosDisponibles;
  final bool cargando;
  final VoidCallback onCanjear;

  const TarjetaPremio({
    super.key,
    required this.premio,
    required this.puntosDisponibles,
    required this.onCanjear,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final categoria = AppCategoriaPremio.porClave(premio.categoria);
    final faltan = premio.costoPuntos - puntosDisponibles;
    final etiqueta = _etiqueta();

    return AppTarjeta(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusLg),
            ),
            child: Container(
              height: AppSizes.imagenPremio,
              color: categoria.color.withValues(alpha: 0.1),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ImagenRemota(
                    url: premio.imagenUrl,
                    altura: AppSizes.imagenPremio,
                    iconoRespaldo: categoria.icono,
                    colorRespaldo: categoria.color,
                    llenarAncho: true,
                  ),
                  if (etiqueta != null)
                    Positioned(
                      top: AppSizes.sm,
                      left: AppSizes.sm,
                      child: etiqueta,
                    ),
                  if (premio.agotado || premio.quedanPocos)
                    Positioned(
                      top: AppSizes.sm,
                      right: AppSizes.sm,
                      child: Etiqueta(
                        texto: premio.agotado
                            ? AppStrings.agotado
                            : AppStrings.quedan(premio.stock!),
                        color: premio.agotado
                            ? AppColors.error
                            : AppColors.warning,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    premio.establecimiento.toUpperCase(),
                    style: textos.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    premio.titulo,
                    style: textos.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: AppSizes.iconSm,
                        color: AppColors.tertiary,
                      ),
                      const SizedBox(width: AppSizes.xs),
                      Flexible(
                        child: Text(
                          AppStrings.puntos(
                            Formatos.entero(premio.costoPuntos),
                          ),
                          style: textos.labelMedium?.copyWith(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  BotonPrimario(
                    texto: premio.agotado
                        ? AppStrings.agotado
                        : faltan > 0
                        ? AppStrings.faltanPuntos(Formatos.entero(faltan))
                        : AppStrings.canjear,
                    onPressed: premio.agotado || faltan > 0 ? null : onCanjear,
                    cargando: cargando,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _etiqueta() {
    return switch (premio.etiqueta) {
      'popular' => const Etiqueta(
        texto: AppStrings.popular,
        color: AppColors.tertiary,
      ),
      'nuevo' => const Etiqueta(
        texto: AppStrings.nuevo,
        color: AppColors.success,
      ),
      _ => null,
    };
  }
}
