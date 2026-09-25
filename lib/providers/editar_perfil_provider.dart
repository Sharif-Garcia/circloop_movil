import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/usuario.dart';
import '../services/servicio_exception.dart';
import '../services/usuario_service.dart';
import '../utils/app_strings.dart';
import 'auth_provider.dart';

/// Estado de la edición del perfil: `data(null)` = sin guardar,
/// `loading` = guardando, `data(usuario)` = guardado, `error(mensaje)`.
final editarPerfilProvider =
    NotifierProvider.autoDispose<EditarPerfilNotifier, AsyncValue<Usuario?>>(
      EditarPerfilNotifier.new,
    );

class EditarPerfilNotifier extends Notifier<AsyncValue<Usuario?>> {
  final UsuarioService _usuarioService = UsuarioService();

  @override
  AsyncValue<Usuario?> build() => const AsyncValue.data(null);

  Future<void> guardar({
    required String nombres,
    required String apellidos,
    int? carreraId,
  }) async {
    final actual = ref.read(authProvider).value;
    if (actual == null) return;

    state = const AsyncValue.loading();

    try {
      final usuario = await _usuarioService.actualizarUsuario(
        actual.copyWith(
          nombres: nombres,
          apellidos: apellidos,
          carreraId: carreraId,
        ),
      );
      if (!ref.mounted) return;

      ref.read(authProvider.notifier).actualizarUsuario(usuario);
      state = AsyncValue.data(usuario);
    } on ServicioException catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e.mensaje, stackTrace);
    } catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(AppStrings.errorGeneral, stackTrace);
    }
  }
}
