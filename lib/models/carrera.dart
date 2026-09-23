class Carrera {
  final int id;
  final String nombre;
  final int facultadId;

  Carrera({required this.id, required this.nombre, required this.facultadId});

  factory Carrera.fromJson(Map<String, dynamic> json) {
    return Carrera(
      id: json['id'],
      nombre: json['nombre'],
      facultadId: json['facultadId'],
    );
  }
}
