import 'progreso_eco.dart';

/// Logro que el usuario gana al cumplir una meta. La regla viene en el
/// JSON ([criterio] + [meta]); si está ganada o no se calcula con
/// [lograda], a partir del progreso de cada usuario.
class Insignia {
  final int id;
  final String nombre;
  final String descripcion;

  /// Nombre del ícono (ver `AppIconos`).
  final String icono;

  /// Qué se mide: entregas, kg, co2, material o nivel.
  final String criterio;
  final double meta;

  /// Solo para el criterio "material": clave del material.
  final String? material;

  Insignia({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.criterio,
    required this.meta,
    this.material,
  });

  factory Insignia.fromJson(Map<String, dynamic> json) {
    return Insignia(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      icono: json['icono'],
      criterio: json['criterio'],
      meta: (json['meta'] as num).toDouble(),
      material: json['material'],
    );
  }

  bool lograda(ProgresoEco progreso) {
    final double valor = switch (criterio) {
      'entregas' => progreso.cantidadEntregas.toDouble(),
      'kg' => progreso.pesoKg,
      'co2' => progreso.co2EvitadoKg,
      'material' => (progreso.entregasPorMaterial[material] ?? 0).toDouble(),
      'nivel' => progreso.nivel.numero.toDouble(),
      _ => 0,
    };

    return valor >= meta;
  }
}
