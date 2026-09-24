import 'codigo_verificacion_service.dart';

/// Implementación REAL (pendiente): envía el código al correo institucional.
///
/// Pasos para activarla:
/// 1. Crear en un backend (por ejemplo Firebase Cloud Functions o una API
///    propia) dos endpoints: uno que genere y envíe el código por correo, y
///    otro que lo verifique. El código y las credenciales del correo deben
///    vivir en el backend, NUNCA dentro de la app.
/// 2. Implementar aquí los dos métodos llamando a esos endpoints
///    (por ejemplo con el paquete `http`).
/// 3. En `providers/recuperar_contrasena_provider.dart`, cambiar
///    `CodigoVerificacionSimulado()` por `CodigoVerificacionCorreo()`.
class CodigoVerificacionCorreo implements CodigoVerificacionService {
  @override
  Future<String?> enviarCodigo(String correo) async {
    // TODO: llamar al backend para que envíe el código a [correo].
    throw UnimplementedError('Envío de código por correo no implementado.');
  }

  @override
  Future<bool> verificarCodigo(String correo, String codigo) async {
    // TODO: pedir al backend que verifique el código.
    throw UnimplementedError('Verificación de código no implementada.');
  }
}
