/// Entrega de material reciclable hecha por un usuario en una estación.
class Entrega {
  final int id;
  final int usuarioId;

  /// Clave del material (ver `AppMaterial`): plastico, papel, aluminio…
  final String material;
  final double pesoKg;
  final double co2EvitadoKg;
  final int puntos;
  final DateTime fecha;

  Entrega({
    required this.id,
    required this.usuarioId,
    required this.material,
    required this.pesoKg,
    required this.co2EvitadoKg,
    required this.puntos,
    required this.fecha,
  });

  factory Entrega.fromJson(Map<String, dynamic> json) {
    return Entrega(
      id: json['id'],
      usuarioId: json['usuarioId'],
      material: json['material'],
      pesoKg: (json['pesoKg'] as num).toDouble(),
      co2EvitadoKg: (json['co2EvitadoKg'] as num).toDouble(),
      puntos: json['puntos'],
      fecha: DateTime.parse(json['fecha']),
    );
  }
}
