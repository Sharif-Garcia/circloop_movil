import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';

/// Enlace "< Volver" que regresa a la pantalla anterior.
class BotonVolver extends StatelessWidget {
  final VoidCallback? onPressed;

  const BotonVolver({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onPressed ?? () => Navigator.maybePop(context),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.zero,
        ),
        icon: const Icon(Icons.arrow_back_ios, size: AppSizes.iconSm * 0.9),
        label: const Text(AppStrings.volver),
      ),
    );
  }
}
