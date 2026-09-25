import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/facultad.dart';
import '../services/facultad_service.dart';

/// Facultades de la universidad. Se cargan una vez y quedan en caché.
final facultadesProvider = FutureProvider<List<Facultad>>((ref) {
  return FacultadService().obtenerFacultades();
});
