/// Premio del catálogo que se puede canjear con puntos. Viene de la base
/// de datos: su imagen, stock y disponibilidad pueden cambiar en cualquier
/// momento sin actualizar la app.
class Premio {
  /// Con este stock o menos se avisa "Quedan N".
  static const int stockBajo = 5;

  final int id;

  /// Clave de la categoría (ver `AppCategoriaPremio`).
  final String categoria;
  final String establecimiento;
  final String titulo;
  final int costoPuntos;

  /// URL de la imagen subida en la base de datos, o `null` si no tiene.
  final String? imagenUrl;

  /// "popular", "nuevo" o `null`.
  final String? etiqueta;

  /// Unidades disponibles; `null` = sin límite (por ejemplo, descuentos).
  final int? stock;

  /// Si es `false`, el premio se retiró del catálogo y no se muestra.
  final bool activo;

  Premio({
    required this.id,
    required this.categoria,
    required this.establecimiento,
    required this.titulo,
    required this.costoPuntos,
    this.imagenUrl,
    this.etiqueta,
    this.stock,
    this.activo = true,
  });

  bool get agotado => stock != null && stock! <= 0;

  bool get quedanPocos => stock != null && stock! > 0 && stock! <= stockBajo;

  factory Premio.fromJson(Map<String, dynamic> json) {
    return Premio(
      id: json['id'],
      categoria: json['categoria'],
      establecimiento: json['establecimiento'],
      titulo: json['titulo'],
      costoPuntos: json['costoPuntos'],
      imagenUrl: json['imagenUrl'],
      etiqueta: json['etiqueta'],
      stock: json['stock'],
      activo: json['activo'] ?? true,
    );
  }

  Premio copyWith({int? stock}) {
    return Premio(
      id: id,
      categoria: categoria,
      establecimiento: establecimiento,
      titulo: titulo,
      costoPuntos: costoPuntos,
      imagenUrl: imagenUrl,
      etiqueta: etiqueta,
      stock: stock ?? this.stock,
      activo: activo,
    );
  }
}
