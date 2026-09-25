import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/nivel_eco.dart';
import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../providers/carreras_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_roles.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../widgets/botones/boton_secundario.dart';
import '../../widgets/comunes/etiqueta.dart';
import '../../widgets/comunes/tarjeta_perfil.dart';
import '../auth/sesion.dart';
import 'editar_perfil_screen.dart';

/// Pestaña de perfil, compartida por todos los roles: datos del usuario,
/// editar perfil y cerrar sesión. Cada rol puede agregar su propia sección
/// en [contenidoRol] (por ejemplo, puntos e insignias en comunidad).
class PerfilScreen extends ConsumerWidget {
  final Widget? contenidoRol;

  const PerfilScreen({super.key, this.contenidoRol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authProvider).value;
    if (usuario == null) return const SizedBox.shrink();

    final carrera = ref.watch(carreraUsuarioProvider).value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TarjetaPerfil(
            usuario: usuario,
            detalle: carrera?.nombre,
            etiqueta: _etiqueta(usuario),
          ),
          if (contenidoRol != null) ...[
            const SizedBox(height: AppSizes.md),
            contenidoRol!,
          ],
          const SizedBox(height: AppSizes.xl),
          BotonSecundario(
            texto: AppStrings.editarPerfil,
            icono: Icons.edit_outlined,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditarPerfilScreen(),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          BotonSecundario(
            texto: AppStrings.cerrarSesion,
            icono: Icons.logout,
            color: AppColors.error,
            onPressed: () => cerrarSesion(context, ref),
          ),
        ],
      ),
    );
  }

  /// Comunidad muestra su nivel; los demás roles, el nombre del rol.
  Widget _etiqueta(Usuario usuario) {
    if (usuario.rolId == AppRol.comunidad) {
      final nivel = NivelEco.paraXp(usuario.puntosHistoricos);
      return Etiqueta(
        texto: AppStrings.nivel(nivel.numero, nivel.nombre),
        icono: Icons.verified_rounded,
        color: AppColors.tertiary,
      );
    }

    final rol = AppRol.porId(usuario.rolId);
    return Etiqueta(texto: rol.nombre, icono: rol.icono, color: rol.color);
  }
}
