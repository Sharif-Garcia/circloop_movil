import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/datos_registro.dart';
import '../models/usuario.dart';
import '../services/servicio_exception.dart';
import '../services/usuario_service.dart';
import '../utils/app_strings.dart';

/// Estado del registro: `data(null)` = sin enviar, `loading` = creando la
/// cuenta, `data(usuario)` = cuenta creada, `error(mensaje)` = falló.
final registroProvider =
    NotifierProvider.autoDispose<RegistroNotifier, AsyncValue<Usuario?>>(
      RegistroNotifier.new,
    );

class RegistroNotifier extends Notifier<AsyncValue<Usuario?>> {
  final UsuarioService _usuarioService = UsuarioService();

  @override
  AsyncValue<Usuario?> build() => const AsyncValue.data(null);

  Future<void> registrar(DatosRegistro datos) async {
    state = const AsyncValue.loading();

    try {
      final usuario = await _usuarioService.registrar(datos);
      if (!ref.mounted) return;
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
