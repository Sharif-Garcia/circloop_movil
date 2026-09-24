/// Contrato para enviar y verificar códigos de recuperación de contraseña.
///
/// La app solo conoce esta interfaz. Hoy se usa [CodigoVerificacionSimulado];
/// para enviar el código de verdad por correo se completa
/// [CodigoVerificacionCorreo] y se cambia UNA línea en
/// `providers/recuperar_contrasena_provider.dart`
/// (`codigoVerificacionServiceProvider`).
abstract class CodigoVerificacionService {
  /// Cantidad de dígitos del código.
  static const int longitudCodigo = 4;

  /// Tiempo que el código es válido.
  static const Duration vigencia = Duration(minutes: 10);

  /// Genera un código y lo envía a [correo].
  ///
  /// Devuelve el código SOLO en modo de prueba (para mostrarlo en pantalla,
  /// ya que no llega ningún correo). Una implementación real devuelve `null`.
  Future<String?> enviarCodigo(String correo);

  /// Indica si [codigo] es el último enviado a [correo] y sigue vigente.
  Future<bool> verificarCodigo(String correo, String codigo);
}
