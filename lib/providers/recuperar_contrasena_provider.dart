import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/codigo_verificacion/codigo_verificacion_service.dart';
import '../services/codigo_verificacion/codigo_verificacion_simulado.dart';
import '../services/usuario_service.dart';
import '../utils/app_strings.dart';

/// Servicio de códigos que usa la app. Para enviar el código por correo de
/// verdad, cambiar `CodigoVerificacionSimulado()` por
/// `CodigoVerificacionCorreo()` (ver codigo_verificacion_correo.dart).
final codigoVerificacionServiceProvider = Provider<CodigoVerificacionService>(
  (ref) => CodigoVerificacionSimulado(),
);

final recuperarContrasenaProvider =
    NotifierProvider.autoDispose<
      RecuperarContrasenaNotifier,
      EstadoRecuperacion
    >(RecuperarContrasenaNotifier.new);

enum PasoRecuperacion { ingresarCorreo, ingresarCodigo, completado }

class EstadoRecuperacion {
  final PasoRecuperacion paso;
  final String correo;
  final bool cargando;
  final String? error;

  /// Solo en modo de prueba: el código "enviado", para mostrarlo en pantalla.
  final String? codigoDePrueba;

  const EstadoRecuperacion({
    this.paso = PasoRecuperacion.ingresarCorreo,
    this.correo = '',
    this.cargando = false,
    this.error,
    this.codigoDePrueba,
  });

  bool get codigoEnviado => paso != PasoRecuperacion.ingresarCorreo;

  EstadoRecuperacion copyWith({
    PasoRecuperacion? paso,
    String? correo,
    bool? cargando,
    String? error,
    String? codigoDePrueba,
  }) {
    return EstadoRecuperacion(
      paso: paso ?? this.paso,
      correo: correo ?? this.correo,
      cargando: cargando ?? this.cargando,
      // error y código no se arrastran: cada acción define los suyos
      error: error,
      codigoDePrueba: codigoDePrueba ?? this.codigoDePrueba,
    );
  }
}

class RecuperarContrasenaNotifier extends Notifier<EstadoRecuperacion> {
  final UsuarioService _usuarioService = UsuarioService();

  CodigoVerificacionService get _codigos =>
      ref.read(codigoVerificacionServiceProvider);

  @override
  EstadoRecuperacion build() => const EstadoRecuperacion();

  Future<void> enviarCodigo(String correo) async {
    state = state.copyWith(cargando: true);

    try {
      final usuario = await _usuarioService.buscarPorCorreo(correo);

      // Solo se envía a correos registrados, pero la respuesta es la misma
      // en ambos casos para no revelar qué correos existen.
      final codigo = usuario != null
          ? await _codigos.enviarCodigo(correo)
          : null;

      if (!ref.mounted) return;

      state = state.copyWith(
        paso: PasoRecuperacion.ingresarCodigo,
        correo: correo,
        cargando: false,
        codigoDePrueba: codigo,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(cargando: false, error: AppStrings.errorGeneral);
    }
  }

  Future<void> restablecerContrasena(String codigo, String nueva) async {
    state = state.copyWith(cargando: true);

    try {
      final valido = await _codigos.verificarCodigo(state.correo, codigo);

      if (!ref.mounted) return;

      if (!valido) {
        state = state.copyWith(
          cargando: false,
          error: AppStrings.codigoInvalido,
        );
        return;
      }

      await _usuarioService.actualizarContrasena(state.correo, nueva);

      if (!ref.mounted) return;

      state = state.copyWith(paso: PasoRecuperacion.completado, cargando: false);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(cargando: false, error: AppStrings.errorGeneral);
    }
  }
}
