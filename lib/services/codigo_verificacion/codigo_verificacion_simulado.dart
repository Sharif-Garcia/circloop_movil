import 'dart:math';

import 'codigo_verificacion_service.dart';

/// Implementación de PRUEBA: no envía ningún correo. Genera el código,
/// lo guarda en memoria y lo devuelve para mostrarlo en pantalla.
class CodigoVerificacionSimulado implements CodigoVerificacionService {
  final Map<String, _CodigoGuardado> _codigos = {};
  final Random _random = Random.secure();

  @override
  Future<String?> enviarCodigo(String correo) async {
    final maximo = pow(10, CodigoVerificacionService.longitudCodigo).toInt();
    final codigo = _random
        .nextInt(maximo)
        .toString()
        .padLeft(CodigoVerificacionService.longitudCodigo, '0');

    _codigos[correo] = _CodigoGuardado(
      codigo,
      DateTime.now().add(CodigoVerificacionService.vigencia),
    );

    return codigo;
  }

  @override
  Future<bool> verificarCodigo(String correo, String codigo) async {
    final guardado = _codigos[correo];

    if (guardado == null || DateTime.now().isAfter(guardado.expira)) {
      return false;
    }

    if (guardado.codigo != codigo) {
      return false;
    }

    // Un código solo se puede usar una vez
    _codigos.remove(correo);
    return true;
  }
}

class _CodigoGuardado {
  final String codigo;
  final DateTime expira;

  _CodigoGuardado(this.codigo, this.expira);
}
