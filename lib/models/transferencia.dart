/// Puntos enviados de un usuario de la comunidad a otro.
class Transferencia {
  final int id;
  final int remitenteId;
  final int destinatarioId;
  final int puntos;
  final String? mensaje;
  final DateTime fecha;

  Transferencia({
    required this.id,
    required this.remitenteId,
    required this.destinatarioId,
    required this.puntos,
    required this.fecha,
    this.mensaje,
  });

  /// Formato esperado por el backend.
  Map<String, dynamic> toJson() {
    return {
      'remitenteId': remitenteId,
      'destinatarioId': destinatarioId,
      'puntos': puntos,
      'mensaje': mensaje,
    };
  }
}
