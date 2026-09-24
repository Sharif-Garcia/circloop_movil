class Usuario {
  final int id;
  final String nombres;
  final String apellidos;
  final String correoInstitucional;
  final String contrasena;
  final int? carreraId;
  final int rolId;
  final bool activo;
  final int puntosTotales;
  final int puntosCanjeados;
  final int puntosHistoricos;
  final String? fotoUrl;

  Usuario({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correoInstitucional,
    required this.contrasena,
    this.carreraId,
    required this.rolId,
    required this.activo,
    required this.puntosTotales,
    required this.puntosCanjeados,
    required this.puntosHistoricos,
    this.fotoUrl,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      correoInstitucional: json['correoInstitucional'],
      contrasena: json['contrasena'],
      carreraId: json['carreraId'],
      rolId: json['rolId'],
      activo: json['activo'],
      puntosTotales: json['puntosTotales'],
      puntosCanjeados: json['puntosCanjeados'],
      puntosHistoricos: json['puntosHistoricos'],
      fotoUrl: json['fotoUrl'],
    );
  }
}
