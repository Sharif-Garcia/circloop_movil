import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../comunes/app_imagen.dart';

/// Ilustración de un paso del onboarding: el GIF animado directamente sobre
/// la pantalla (sin tarjeta), con un resplandor verde difuminado detrás y
/// íconos pequeños flotando alrededor. Si el GIF aún no existe, muestra
/// `icono`.
class IlustracionPaso extends StatelessWidget {
  final String imagen;
  final IconData icono;
  final Color color;
  final List<IconData> iconosSecundarios;

  const IlustracionPaso({
    super.key,
    required this.imagen,
    required this.icono,
    required this.color,
    this.iconosSecundarios = const [],
  });

  // Dónde flotan los íconos pequeños: en las esquinas, que el GIF deja libres
  static const List<Alignment> _posiciones = [
    Alignment(0.95, -0.85),
    Alignment(-0.95, 0.75),
    Alignment(-0.9, -0.9),
    Alignment(0.9, 0.85),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricciones) {
        // Tan grande como permita el ancho, sin pasar del tamaño máximo
        final lado = math.min(
          restricciones.maxWidth,
          AppSizes.ilustracionOnboarding,
        );

        return SizedBox.square(
          dimension: lado,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Resplandor principal detrás del GIF
              _resplandor(lado * 1.2, 0.16),
              // Resplandor secundario, arriba a la derecha, para dar profundidad
              Align(
                alignment: const Alignment(0.7, -0.8),
                child: _resplandor(lado * 0.55, 0.10),
              ),
              AppImagen(
                ruta: imagen,
                altura: lado,
                ancho: lado,
                ajuste: BoxFit.contain,
                iconoRespaldo: icono,
                colorRespaldo: color,
              ),
              for (
                var i = 0;
                i < iconosSecundarios.length && i < _posiciones.length;
                i++
              )
                Align(
                  alignment: _posiciones[i],
                  child: _insignia(iconosSecundarios[i]),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Círculo verde que se desvanece hacia los bordes (sin contorno).
  Widget _resplandor(double diametro, double opacidad) {
    return IgnorePointer(
      child: Container(
        width: diametro,
        height: diametro,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.primary.withValues(alpha: opacidad),
              AppColors.primary.withValues(alpha: opacidad * 0.4),
              AppColors.primary.withValues(alpha: 0),
            ],
            stops: const [0, 0.55, 1],
          ),
        ),
      ),
    );
  }

  Widget _insignia(IconData icono) {
    return Container(
      width: AppSizes.insigniaIlustracion,
      height: AppSizes.insigniaIlustracion,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: AppSizes.md,
            offset: const Offset(0, AppSizes.xs),
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: AppSizes.lg,
            spreadRadius: -AppSizes.xs,
            offset: const Offset(0, AppSizes.sm),
          ),
        ],
      ),
      child: Icon(icono, size: AppSizes.iconMd, color: color),
    );
  }
}
