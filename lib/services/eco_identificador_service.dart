import '../models/usuario.dart';

/// Código Eco-Identificador: el valor que va dentro del QR personal del
/// usuario y que el operador escanea en la estación para registrar una
/// entrega a su nombre.
class EcoIdentificadorService {
  static const String prefijo = 'CIRC-';
  static const int _digitos = 6;

  /// Código del usuario, por ejemplo "CIRC-000001".
  Future<String> obtenerCodigo(Usuario usuario) async {
    // TODO: cuando exista el backend, pedir un código firmado y con
    // vencimiento (para que no se pueda copiar el QR de otra persona).
    // La pantalla del QR no necesita cambios.
    return '$prefijo${usuario.id.toString().padLeft(_digitos, '0')}';
  }

  /// Id del usuario dentro de un código escaneado, o `null` si el código no
  /// es válido. Lo usará la pantalla de escaneo del operador.
  static int? idDesdeCodigo(String codigo) {
    if (!codigo.startsWith(prefijo)) return null;
    return int.tryParse(codigo.substring(prefijo.length));
  }
}
