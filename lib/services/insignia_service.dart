import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/insignia.dart';

class InsigniaService {
  Future<List<Insignia>> obtenerInsignias() async {
    final String respuesta = await rootBundle.loadString(
      'assets/data/insignias.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return datos.map((dato) => Insignia.fromJson(dato)).toList();
  }
}
