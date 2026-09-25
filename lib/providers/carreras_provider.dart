import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/carrera.dart';
import '../services/carrera_service.dart';
import 'auth_provider.dart';

/// Carreras ordenadas alfabéticamente. Se cargan una vez y quedan en caché.
final carrerasProvider = FutureProvider<List<Carrera>>((ref) async {
  final carreras = await CarreraService().obtenerCarreras();
  return carreras..sort((a, b) => a.nombre.compareTo(b.nombre));
});

/// Carrera del usuario en sesión, o `null` si no tiene.
final carreraUsuarioProvider = FutureProvider.autoDispose<Carrera?>((
  ref,
) async {
  final carreraId = ref.watch(authProvider).value?.carreraId;
  if (carreraId == null) return null;

  final carreras = await ref.watch(carrerasProvider.future);
  return carreras.where((carrera) => carrera.id == carreraId).firstOrNull;
});
