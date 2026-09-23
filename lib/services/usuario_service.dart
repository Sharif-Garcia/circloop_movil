import 'dart:convert';

import 'package:circloop_movil/models/usuario.dart';
import 'package:flutter/services.dart';

class UsuarioService {
  Future<List<Usuario>> obtenerUsuarios() async {
    final String respuesta = await rootBundle.loadString(
      'assets/data/usuarios.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return datos.map((dato) => Usuario.fromJson(dato)).toList();
  }
}
