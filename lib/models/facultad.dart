class Facultad {
  final int id;
  final String nombre;

  Facultad({required this.id, required this.nombre});

  factory Facultad.fromJson(Map<String, dynamic> json) {
    return Facultad(id: json['id'], nombre: json['nombre']);
  }
}
