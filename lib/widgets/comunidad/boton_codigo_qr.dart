import 'package:flutter/material.dart';

import '../../screens/comunidad/codigo_qr_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';

/// Botón flotante "Mi Código QR" que abre el Código Eco-Identificador.
class BotonCodigoQr extends StatelessWidget {
  const BotonCodigoQr({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CodigoQrScreen()),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      icon: const Icon(Icons.qr_code_2),
      label: const Text(AppStrings.miCodigoQr),
    );
  }
}
