import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/carrera.dart';
import '../services/carrera_service.dart';

/// Carreras ordenadas alfabéticamente. Se cargan una vez y quedan en caché.
final carrerasProvider = FutureProvider<List<Carrera>>((ref) async {
  final carreras = await CarreraService().obtenerCarreras();
  return carreras..sort((a, b) => a.nombre.compareTo(b.nombre));
});
