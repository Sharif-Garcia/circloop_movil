import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/carrera.dart';

class CarreraService {
  Future<List<Carrera>> obtenerCarreras() async {
    final String respuesta = await rootBundle.loadString(
      'assets/data/carreras.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return datos.map((dato) => Carrera.fromJson(dato)).toList();
  }
}
