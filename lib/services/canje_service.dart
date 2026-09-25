import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/canje.dart';
import '../models/premio.dart';
import '../models/usuario.dart';
import '../utils/app_strings.dart';
import '../utils/app_tipos_notificacion.dart';
import 'notificacion_service.dart';
import 'premio_service.dart';
import 'servicio_exception.dart';
import 'usuario_service.dart';

class CanjeService {
  static const String prefijoCodigo = 'CJ-';
  static const String _caracteresCodigo = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const int _longitudCodigo = 6;

  // Mientras no exista un backend, los canjes nuevos se guardan en memoria
  // (se pierden al cerrar la app).
  static final List<Canje> _canjesNuevos = [];

  @visibleForTesting
  static void reiniciarDatosEnMemoria() => _canjesNuevos.clear();

  final UsuarioService _usuarioService = UsuarioService();
  final PremioService _premioService = PremioService();
  final NotificacionService _notificacionService = NotificacionService();
  final Random _random = Random.secure();

  Future<List<Canje>> obtenerCanjes() async {
    final String respuesta = await rootBundle.loadString(
      'assets/data/canjes.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return [...datos.map((dato) => Canje.fromJson(dato)), ..._canjesNuevos];
  }

  /// Canjes de un usuario, del más reciente al más antiguo.
  Future<List<Canje>> obtenerPorUsuario(int usuarioId) async {
    final canjes = await obtenerCanjes();

    return canjes.where((canje) => canje.usuarioId == usuarioId).toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  /// Canjea [premio]: descuenta los puntos y genera el código para
  /// reclamarlo. Devuelve el canje y el usuario con los puntos al día.
  ///
  /// Lanza [ServicioException] si no le alcanzan los puntos.
  Future<({Canje canje, Usuario usuario})> canjear(
    Usuario usuario,
    Premio premio,
  ) async {
    // TODO: cuando exista el backend, enviar la solicitud de canje y usar el
    // canje y los puntos que responda (el backend debe validar los puntos).
    if (premio.agotado) {
      throw const ServicioException(AppStrings.premioAgotado);
    }

    if (usuario.puntosTotales < premio.costoPuntos) {
      throw const ServicioException(AppStrings.puntosInsuficientes);
    }

    final canjes = await obtenerCanjes();
    final canje = Canje(
      id: canjes.fold<int>(0, (max, c) => c.id > max ? c.id : max) + 1,
      usuarioId: usuario.id,
      premioId: premio.id,
      codigo: _generarCodigo(canjes),
      fecha: DateTime.now(),
      estado: Canje.pendiente,
    );

    final actualizado = await _usuarioService.actualizarUsuario(
      usuario.copyWith(
        puntosTotales: usuario.puntosTotales - premio.costoPuntos,
        puntosCanjeados: usuario.puntosCanjeados + premio.costoPuntos,
      ),
    );

    await _premioService.descontarStock(premio);
    _canjesNuevos.add(canje);

    await _notificacionService.crear(
      usuarioId: usuario.id,
      tipo: AppTipoNotificacion.canje,
      titulo: AppStrings.notifCanjeTitulo,
      mensaje: AppStrings.notifCanjeMensaje(
        premio.titulo,
        premio.establecimiento,
        canje.codigo,
      ),
    );
    return (canje: canje, usuario: actualizado);
  }

  /// Código tipo "CJ-7Q4M2X" (sin 0/O ni 1/I para evitar confusiones),
  /// distinto de los existentes.
  String _generarCodigo(List<Canje> existentes) {
    final usados = existentes.map((c) => c.codigo).toSet();
    String codigo;

    do {
      codigo =
          prefijoCodigo +
          List.generate(
            _longitudCodigo,
            (_) => _caracteresCodigo[_random.nextInt(_caracteresCodigo.length)],
          ).join();
    } while (usados.contains(codigo));

    return codigo;
  }
}
