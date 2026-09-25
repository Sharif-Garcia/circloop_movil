import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/entrega.dart';
import '../services/entrega_service.dart';
import 'auth_provider.dart';

/// Entregas del usuario en sesión (más recientes primero).
final entregasUsuarioProvider = FutureProvider.autoDispose<List<Entrega>>((
  ref,
) async {
  final usuario = ref.watch(authProvider).value;
  if (usuario == null) return [];

  return EntregaService().obtenerPorUsuario(usuario.id);
});
