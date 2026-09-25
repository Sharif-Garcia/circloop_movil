import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notificacion.dart';
import '../services/notificacion_service.dart';
import 'auth_provider.dart';

/// Notificaciones del usuario en sesión (más recientes primero), con las
/// acciones para marcarlas como leídas. Se vuelve a cargar cuando cambia el
/// usuario en sesión (por ejemplo, después de un canje).
final notificacionesProvider =
    AsyncNotifierProvider.autoDispose<
      NotificacionesNotifier,
      List<Notificacion>
    >(NotificacionesNotifier.new);

/// Cantidad de notificaciones sin leer (para el globo de la campana).
final notificacionesNoLeidasProvider = Provider.autoDispose<int>((ref) {
  final notificaciones = ref.watch(notificacionesProvider).value ?? const [];
  return notificaciones.where((n) => !n.leida).length;
});

class NotificacionesNotifier extends AsyncNotifier<List<Notificacion>> {
  final NotificacionService _servicio = NotificacionService();

  @override
  Future<List<Notificacion>> build() async {
    final usuario = ref.watch(authProvider).value;
    if (usuario == null) return [];

    return _servicio.obtenerPorUsuario(usuario.id);
  }

  Future<void> marcarLeida(Notificacion notificacion) async {
    if (notificacion.leida) return;
    await _marcar([notificacion.id]);
  }

  Future<void> marcarTodasLeidas() async {
    final pendientes = (state.value ?? const <Notificacion>[])
        .where((n) => !n.leida)
        .map((n) => n.id)
        .toList();
    if (pendientes.isEmpty) return;
    await _marcar(pendientes);
  }

  Future<void> _marcar(List<int> ids) async {
    final actuales = state.value ?? const <Notificacion>[];

    // Se muestra de inmediato; el guardado va detrás
    state = AsyncValue.data([
      for (final n in actuales)
        ids.contains(n.id) ? n.copyWith(leida: true) : n,
    ]);

    await _servicio.marcarLeidas(ids);
  }
}
