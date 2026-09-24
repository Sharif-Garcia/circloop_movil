import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../screens/comunidad/comunidad_home_screen.dart';
import '../screens/operador/operador_home_screen.dart';
import '../screens/punto_canje/punto_canje_home_screen.dart';
import '../screens/admin/admin_home_screen.dart';

class RoleRouter {
  static Widget obtenerPantalla(Usuario usuario) {
    switch (usuario.rolId) {
      case 1:
        return const ComunidadHomeScreen();

      case 2:
        return const OperadorHomeScreen();

      case 3:
        return const PuntoCanjeHomeScreen();

      case 4:
        return const AdminHomeScreen();

      default:
        return const Scaffold(body: Center(child: Text('Rol no válido.')));
    }
  }
}
