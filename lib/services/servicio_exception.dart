/// Error esperado de un servicio, con un mensaje listo para mostrar al
/// usuario (por ejemplo, "Este correo ya tiene una cuenta").
///
/// Cualquier otra excepción se considera un error inesperado y la interfaz
/// muestra un mensaje genérico.
class ServicioException implements Exception {
  final String mensaje;

  const ServicioException(this.mensaje);

  @override
  String toString() => mensaje;
}
