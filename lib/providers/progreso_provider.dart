import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/insignia.dart';
import '../models/progreso_eco.dart';
import '../models/usuario.dart';
import '../services/eco_identificador_service.dart';
import '../services/insignia_service.dart';
import '../services/usuario_service.dart';
import '../utils/app_roles.dart';
import 'auth_provider.dart';
import 'entregas_provider.dart';

/// Progreso ecológico del usuario en sesión (kg, CO₂, entregas, nivel).
final progresoUsuarioProvider = FutureProvider.autoDispose<ProgresoEco?>((
  ref,
) async {
  final usuario = ref.watch(authProvider).value;
  if (usuario == null) return null;

  final entregas = await ref.watch(entregasUsuarioProvider.future);
  return ProgresoEco.desde(usuario, entregas);
});

/// Código Eco-Identificador (contenido del QR) del usuario en sesión.
final ecoIdentificadorProvider = FutureProvider.autoDispose<String?>((
  ref,
) async {
  final usuario = ref.watch(authProvider).value;
  if (usuario == null) return null;

  return EcoIdentificadorService().obtenerCodigo(usuario);
});

/// Todas las insignias con su estado para el usuario en sesión.
final insigniasUsuarioProvider =
    FutureProvider.autoDispose<List<({Insignia insignia, bool lograda})>>((
      ref,
    ) async {
      final progreso = await ref.watch(progresoUsuarioProvider.future);
      final insignias = await InsigniaService().obtenerInsignias();

      return [
        for (final insignia in insignias)
          (
            insignia: insignia,
            lograda: progreso != null && insignia.lograda(progreso),
          ),
      ];
    });

/// Usuarios del rol comunidad ordenados por puntos históricos (mayor a
/// menor). Base del ranking del campus.
final rankingComunidadProvider = FutureProvider.autoDispose<List<Usuario>>((
  ref,
) async {
  // Se vuelve a calcular si cambia el usuario en sesión
  ref.watch(authProvider);

  final usuarios = await UsuarioService().obtenerUsuarios();
  return usuarios.where((u) => u.rolId == AppRol.comunidad && u.activo).toList()
    ..sort((a, b) => b.puntosHistoricos.compareTo(a.puntosHistoricos));
});

/// Puesto del usuario en sesión en el ranking (1 = primero), o `null`.
final puestoRankingProvider = FutureProvider.autoDispose<int?>((ref) async {
  final usuario = ref.watch(authProvider).value;
  if (usuario == null) return null;

  final ranking = await ref.watch(rankingComunidadProvider.future);
  final indice = ranking.indexWhere((u) => u.id == usuario.id);
  return indice == -1 ? null : indice + 1;
});
