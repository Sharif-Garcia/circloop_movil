import 'dart:convert';

import 'package:circloop_movil/models/rol.dart';
import 'package:flutter/services.dart';

class RolService {
  Future<List<Rol>> obtenerRoles() async {
    final String respuesta = await rootBundle.loadString(
      'assets/data/roles.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return datos.map((dato) => Rol.fromJson(dato)).toList();
  }
}
