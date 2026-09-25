import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/notificacion.dart';

class NotificacionService {
  // Mientras no exista un backend, las notificaciones nuevas y las marcadas
  // como leídas se guardan en memoria (se pierden al cerrar la app).
  static final List<Notificacion> _nuevas = [];
  static final Set<int> _leidas = {};

  @visibleForTesting
  static void reiniciarDatosEnMemoria() {
    _nuevas.clear();
    _leidas.clear();
  }

  Future<List<Notificacion>> obtenerNotificaciones() async {
    final String respuesta = await rootBundle.loadString(
      'assets/data/notificaciones.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return [
      ...datos.map((dato) => Notificacion.fromJson(dato)),
      ..._nuevas,
    ].map((n) => _leidas.contains(n.id) ? n.copyWith(leida: true) : n).toList();
  }

  /// Notificaciones de un usuario, de la más reciente a la más antigua.
  Future<List<Notificacion>> obtenerPorUsuario(int usuarioId) async {
    final notificaciones = await obtenerNotificaciones();

    return notificaciones.where((n) => n.usuarioId == usuarioId).toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  /// Crea una notificación para [usuarioId]. La usan los demás servicios
  /// cuando pasa algo que el usuario debe saber (canje, puntos recibidos…).
  Future<Notificacion> crear({
    required int usuarioId,
    required String tipo,
    required String titulo,
    required String mensaje,
  }) async {
    // TODO: cuando exista el backend, las notificaciones las crea el
    // servidor (y puede enviarlas como push). Este método desaparece.
    final existentes = await obtenerNotificaciones();
    final notificacion = Notificacion(
      id: existentes.fold<int>(0, (max, n) => n.id > max ? n.id : max) + 1,
      usuarioId: usuarioId,
      tipo: tipo,
      titulo: titulo,
      mensaje: mensaje,
      fecha: DateTime.now(),
    );

    _nuevas.add(notificacion);
    return notificacion;
  }

  Future<void> marcarLeidas(Iterable<int> ids) async {
    // TODO: enviar al backend cuando exista.
    _leidas.addAll(ids);
  }
}
