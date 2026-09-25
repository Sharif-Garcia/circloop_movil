/// Datos que el usuario llena en el formulario de registro.
class DatosRegistro {
  final String nombres;
  final String apellidos;
  final String correoInstitucional;
  final String contrasena;
  final int carreraId;

  const DatosRegistro({
    required this.nombres,
    required this.apellidos,
    required this.correoInstitucional,
    required this.contrasena,
    required this.carreraId,
  });

  /// Formato esperado por el backend (mismas claves que usuarios.json).
  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'correoInstitucional': correoInstitucional,
      'contrasena': contrasena,
      'carreraId': carreraId,
    };
  }
}
