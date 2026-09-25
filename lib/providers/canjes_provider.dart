import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/canje.dart';
import '../models/premio.dart';
import '../services/canje_service.dart';
import '../services/premio_service.dart';
import '../services/servicio_exception.dart';
import '../utils/app_strings.dart';
import 'auth_provider.dart';

/// Catálogo de premios (del más barato al más caro). Queda en caché.
final premiosProvider = FutureProvider<List<Premio>>((ref) {
  return PremioService().obtenerPremios();
});

/// Canjes del usuario en sesión con su premio, del más reciente al más
/// antiguo.
final canjesUsuarioProvider =
    FutureProvider.autoDispose<List<({Canje canje, Premio? premio})>>((
      ref,
    ) async {
      final usuario = ref.watch(authProvider).value;
      if (usuario == null) return [];

      final premios = await ref.watch(premiosProvider.future);
      final canjes = await CanjeService().obtenerPorUsuario(usuario.id);

      return [
        for (final canje in canjes)
          (
            canje: canje,
            premio: premios.where((p) => p.id == canje.premioId).firstOrNull,
          ),
      ];
    });

/// Estado del canje en curso: `data(null)` = ninguno, `loading` =
/// canjeando, `data(canje)` = hecho, `error(mensaje)` = falló.
final canjearProvider =
    NotifierProvider.autoDispose<CanjearNotifier, AsyncValue<Canje?>>(
      CanjearNotifier.new,
    );

class CanjearNotifier extends Notifier<AsyncValue<Canje?>> {
  final CanjeService _canjeService = CanjeService();

  @override
  AsyncValue<Canje?> build() => const AsyncValue.data(null);

  Future<void> canjear(Premio premio) async {
    final usuario = ref.read(authProvider).value;
    if (usuario == null) return;

    state = const AsyncValue.loading();

    try {
      final resultado = await _canjeService.canjear(usuario, premio);
      if (!ref.mounted) return;

      // Los puntos nuevos se ven en toda la app (barra superior, perfil…)
      ref.read(authProvider.notifier).actualizarUsuario(resultado.usuario);
      ref.invalidate(canjesUsuarioProvider);
      // El stock del premio cambió: se vuelve a pedir el catálogo
      ref.invalidate(premiosProvider);
      state = AsyncValue.data(resultado.canje);
    } on ServicioException catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e.mensaje, stackTrace);
    } catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(AppStrings.errorGeneral, stackTrace);
    }
  }
}
