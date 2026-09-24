import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/usuario.dart';
import '../services/usuario_service.dart';

final authProvider = NotifierProvider<AuthNotifier, AsyncValue<Usuario?>>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AsyncValue<Usuario?>> {
  final UsuarioService _usuarioService = UsuarioService();

  @override
  AsyncValue<Usuario?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> iniciarSesion(String correo, String contrasena) async {
    state = const AsyncValue.loading();

    try {
      final usuario = await _usuarioService.iniciarSesion(correo, contrasena);

      if (usuario == null) {
        state = AsyncValue.error(
          'Correo o contraseña incorrectos.',
          StackTrace.current,
        );
        return;
      }

      if (!usuario.activo) {
        state = AsyncValue.error(
          'El usuario se encuentra inactivo.',
          StackTrace.current,
        );
        return;
      }

      state = AsyncValue.data(usuario);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void cerrarSesion() {
    state = const AsyncValue.data(null);
  }
}
