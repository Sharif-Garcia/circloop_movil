/// Aviso para un usuario (entrega registrada, canje, puntos recibidos…).
class Notificacion {
  final int id;
  final int usuarioId;

  /// Clave del tipo (ver `AppTipoNotificacion`): entrega, canje,
  /// transferencia, insignia, sistema.
  final String tipo;
  final String titulo;
  final String mensaje;
  final DateTime fecha;
  final bool leida;

  Notificacion({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    this.leida = false,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'],
      usuarioId: json['usuarioId'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      mensaje: json['mensaje'],
      fecha: DateTime.parse(json['fecha']),
      leida: json['leida'] ?? false,
    );
  }

  Notificacion copyWith({bool? leida}) {
    return Notificacion(
      id: id,
      usuarioId: usuarioId,
      tipo: tipo,
      titulo: titulo,
      mensaje: mensaje,
      fecha: fecha,
      leida: leida ?? this.leida,
    );
  }
}
