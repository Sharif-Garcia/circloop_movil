import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transferencia.dart';
import '../services/servicio_exception.dart';
import '../services/transferencia_service.dart';
import '../utils/app_strings.dart';
import 'auth_provider.dart';

/// Estado de la transferencia: `data(null)` = sin enviar, `loading` =
/// enviando, `data(transferencia)` = hecha, `error(mensaje)` = falló.
final transferirProvider =
    NotifierProvider.autoDispose<
      TransferirNotifier,
      AsyncValue<Transferencia?>
    >(TransferirNotifier.new);

class TransferirNotifier extends Notifier<AsyncValue<Transferencia?>> {
  final TransferenciaService _servicio = TransferenciaService();

  @override
  AsyncValue<Transferencia?> build() => const AsyncValue.data(null);

  Future<void> transferir({
    required String correoDestino,
    required int puntos,
    String? mensaje,
  }) async {
    final usuario = ref.read(authProvider).value;
    if (usuario == null) return;

    state = const AsyncValue.loading();

    try {
      final resultado = await _servicio.transferir(
        remitente: usuario,
        correoDestino: correoDestino,
        puntos: puntos,
        mensaje: mensaje,
      );
      if (!ref.mounted) return;

      ref.read(authProvider.notifier).actualizarUsuario(resultado.remitente);
      state = AsyncValue.data(resultado.transferencia);
    } on ServicioException catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e.mensaje, stackTrace);
    } catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(AppStrings.errorGeneral, stackTrace);
    }
  }
}
