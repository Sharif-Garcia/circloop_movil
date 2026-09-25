import 'package:flutter/foundation.dart';

import '../models/transferencia.dart';
import '../models/usuario.dart';
import '../utils/app_roles.dart';
import '../utils/app_strings.dart';
import '../utils/app_tipos_notificacion.dart';
import '../utils/formatos.dart';
import 'notificacion_service.dart';
import 'servicio_exception.dart';
import 'usuario_service.dart';

class TransferenciaService {
  // Mientras no exista un backend, las transferencias se guardan en memoria
  // (se pierden al cerrar la app).
  static final List<Transferencia> _transferencias = [];

  @visibleForTesting
  static void reiniciarDatosEnMemoria() => _transferencias.clear();

  final UsuarioService _usuarioService = UsuarioService();
  final NotificacionService _notificacionService = NotificacionService();

  /// Envía [puntos] de [remitente] al usuario con [correoDestino]. Solo
  /// cambian los puntos disponibles: los históricos (XP, ranking) no se
  /// transfieren. Devuelve la transferencia y el remitente actualizado.
  ///
  /// Lanza [ServicioException] si el destinatario no existe, no es un
  /// miembro activo de la comunidad, es el mismo remitente o no alcanzan
  /// los puntos.
  Future<({Transferencia transferencia, Usuario remitente})> transferir({
    required Usuario remitente,
    required String correoDestino,
    required int puntos,
    String? mensaje,
  }) async {
    // TODO: cuando exista el backend, enviar `transferencia.toJson()` y usar
    // lo que responda. El backend debe repetir TODAS estas validaciones y
    // mover los puntos en una sola operación.
    if (puntos <= 0 || puntos > remitente.puntosTotales) {
      throw const ServicioException(AppStrings.puntosInsuficientesTransferir);
    }

    final destinatario = await _usuarioService.buscarPorCorreo(correoDestino);

    if (destinatario == null) {
      throw const ServicioException(AppStrings.destinatarioNoExiste);
    }
    if (destinatario.id == remitente.id) {
      throw const ServicioException(AppStrings.transferenciaASiMismo);
    }
    if (destinatario.rolId != AppRol.comunidad || !destinatario.activo) {
      throw const ServicioException(AppStrings.destinatarioNoValido);
    }

    final remitenteActualizado = await _usuarioService.actualizarUsuario(
      remitente.copyWith(puntosTotales: remitente.puntosTotales - puntos),
    );
    await _usuarioService.actualizarUsuario(
      destinatario.copyWith(puntosTotales: destinatario.puntosTotales + puntos),
    );

    final transferencia = Transferencia(
      id: _transferencias.length + 1,
      remitenteId: remitente.id,
      destinatarioId: destinatario.id,
      puntos: puntos,
      mensaje: mensaje,
      fecha: DateTime.now(),
    );
    _transferencias.add(transferencia);

    await _notificacionService.crear(
      usuarioId: destinatario.id,
      tipo: AppTipoNotificacion.transferencia,
      titulo: AppStrings.notifTransferenciaTitulo,
      mensaje: AppStrings.notifTransferenciaMensaje(
        '${remitente.nombres} ${remitente.apellidos}',
        Formatos.entero(puntos),
        mensaje,
      ),
    );

    return (transferencia: transferencia, remitente: remitenteActualizado);
  }
}
