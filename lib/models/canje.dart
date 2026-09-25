/// Premio canjeado por un usuario. El [codigo] (y su QR) se presenta en el
/// establecimiento para reclamar el premio.
class Canje {
  static const String pendiente = 'pendiente';
  static const String entregado = 'entregado';

  final int id;
  final int usuarioId;
  final int premioId;
  final String codigo;
  final DateTime fecha;

  /// [pendiente] (por reclamar) o [entregado].
  final String estado;

  Canje({
    required this.id,
    required this.usuarioId,
    required this.premioId,
    required this.codigo,
    required this.fecha,
    required this.estado,
  });

  bool get estaPendiente => estado == pendiente;

  factory Canje.fromJson(Map<String, dynamic> json) {
    return Canje(
      id: json['id'],
      usuarioId: json['usuarioId'],
      premioId: json['premioId'],
      codigo: json['codigo'],
      fecha: DateTime.parse(json['fecha']),
      estado: json['estado'],
    );
  }
}
