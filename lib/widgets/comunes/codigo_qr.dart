import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Código QR con los colores de la marca dentro de un marco verde. Si
/// [codigo] es `null` muestra un indicador de carga del mismo tamaño.
class CodigoQr extends StatelessWidget {
  final String? codigo;
  final double tamano;

  const CodigoQr({
    super.key,
    required this.codigo,
    this.tamano = AppSizes.codigoQr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: codigo == null
          ? SizedBox.square(
              dimension: tamano,
              child: const Center(child: CircularProgressIndicator()),
            )
          : QrImageView(
              data: codigo!,
              size: tamano,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.primaryDark,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.primaryDark,
              ),
            ),
    );
  }
}
