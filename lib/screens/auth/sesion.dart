import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_roles.dart';
import '../comunidad/panel_comunidad_screen.dart';
import '../inicio/inicio_rol_screen.dart';
import 'login_screen.dart';

/// Pantalla principal de cada rol después de iniciar sesión.
/// Al crear el panel de otro rol, se agrega aquí su caso.
Widget pantallaInicioPorRol(Usuario usuario) {
  switch (usuario.rolId) {
    case AppRol.comunidad:
      return const PanelComunidadScreen();
    default:
      // TODO: reemplazar por el panel de operador, punto de canje y admin.
      return const InicioRolScreen();
  }
}

/// Cierra la sesión y vuelve al login, desde cualquier pantalla.
void cerrarSesion(BuildContext context, WidgetRef ref) {
  ref.read(authProvider.notifier).cerrarSesion();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (ruta) => false,
  );
}
