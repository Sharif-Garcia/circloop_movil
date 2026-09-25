import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/entrega.dart';

class EntregaService {
  Future<List<Entrega>> obtenerEntregas() async {
    final String respuesta = await rootBundle.loadString(
      'assets/data/entregas.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return datos.map((dato) => Entrega.fromJson(dato)).toList();
  }

  /// Entregas de un usuario, de la más reciente a la más antigua.
  Future<List<Entrega>> obtenerPorUsuario(int usuarioId) async {
    final entregas = await obtenerEntregas();

    return entregas.where((entrega) => entrega.usuarioId == usuarioId).toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
  }
}
