import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:circloop_movil/models/facultad.dart';

class FacultadService {
  Future<List<Facultad>> obtenerFacultades() async {
    final String respuesta = await rootBundle.loadString(
      'assets/data/facultades.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return datos.map((dato) => Facultad.fromJson(dato)).toList();
  }
}
