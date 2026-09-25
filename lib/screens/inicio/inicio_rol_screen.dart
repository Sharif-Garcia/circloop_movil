import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_roles.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../widgets/comunes/app_tarjeta.dart';
import '../auth/sesion.dart';

/// Pantalla TEMPORAL de inicio para los roles que aún no tienen panel
/// (operador, punto de canje, administrador).
class InicioRolScreen extends ConsumerWidget {
  const InicioRolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authProvider).value;

    // Mientras se cierra la sesión el usuario ya es null
    if (usuario == null) return const Scaffold();

    final rol = AppRol.porId(usuario.rolId);
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(rol.tituloPanel),
        backgroundColor: rol.color,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            tooltip: AppStrings.cerrarSesion,
            icon: const Icon(Icons.logout),
            onPressed: () => cerrarSesion(context, ref),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(rol.icono, size: AppSizes.iconXxl * 0.8, color: rol.color),
            const SizedBox(height: AppSizes.lg),
            Text(
              AppStrings.saludo(usuario.nombres),
              style: textos.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              AppStrings.rolActual(rol.nombre),
              style: textos.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            const AppTarjeta(
              child: Text(
                AppStrings.descripcionPanel,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
