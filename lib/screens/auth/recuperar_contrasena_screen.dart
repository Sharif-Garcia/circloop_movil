import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/recuperar_contrasena_provider.dart';
import '../../services/codigo_verificacion/codigo_verificacion_service.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/validators.dart';
import '../../widgets/comunes/app_mensaje.dart';
import '../../widgets/comunes/app_tarjeta.dart';
import '../../widgets/botones/boton_primario.dart';
import '../../widgets/botones/boton_volver.dart';
import '../../widgets/formularios/campo_codigo.dart';
import '../../widgets/formularios/campo_contrasena.dart';
import '../../widgets/formularios/campo_texto.dart';
import '../../widgets/comunes/dialogo_exito.dart';
import '../../widgets/comunes/encabezado_seccion.dart';

class RecuperarContrasenaScreen extends ConsumerStatefulWidget {
  const RecuperarContrasenaScreen({super.key});

  @override
  ConsumerState<RecuperarContrasenaScreen> createState() =>
      _RecuperarContrasenaScreenState();
}

class _RecuperarContrasenaScreenState
    extends ConsumerState<RecuperarContrasenaScreen> {
  final _formCorreo = GlobalKey<FormState>();
  final _formContrasena = GlobalKey<FormState>();

  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarController = TextEditingController();

  String _codigo = '';

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  void _enviarCodigo() {
    if (!_formCorreo.currentState!.validate()) return;

    ref
        .read(recuperarContrasenaProvider.notifier)
        .enviarCodigo(_correoController.text.trim());
  }

  void _restablecerContrasena() {
    final contrasenaValida = _formContrasena.currentState!.validate();

    if (_codigo.length < CodigoVerificacionService.longitudCodigo) {
      AppMensaje.aviso(context, AppStrings.codigoIncompleto);
      return;
    }

    if (!contrasenaValida) return;

    ref
        .read(recuperarContrasenaProvider.notifier)
        .restablecerContrasena(_codigo, _contrasenaController.text);
  }

  void _escucharCambios(
    EstadoRecuperacion? anterior,
    EstadoRecuperacion actual,
  ) {
    if (actual.error != null && actual.error != anterior?.error) {
      AppMensaje.error(context, actual.error!);
    }

    if (anterior?.paso == actual.paso) return;

    switch (actual.paso) {
      case PasoRecuperacion.ingresarCodigo:
        AppMensaje.info(context, AppStrings.mensajeCodigoEnviado);
      case PasoRecuperacion.completado:
        mostrarDialogoExito(
          context,
          titulo: AppStrings.tituloContrasenaActualizada,
          mensaje: AppStrings.mensajeContrasenaActualizada,
          textoBoton: AppStrings.irAlLogin,
          alAceptar: () => Navigator.pop(context),
        );
      case PasoRecuperacion.ingresarCorreo:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(recuperarContrasenaProvider);
    final textos = Theme.of(context).textTheme;

    ref.listen(recuperarContrasenaProvider, _escucharCambios);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BotonVolver(),

              const SizedBox(height: AppSizes.md),

              const EncabezadoSeccion(
                titulo: AppStrings.tituloRecuperar,
                subtitulo: AppStrings.subtituloRecuperar,
              ),

              const SizedBox(height: AppSizes.lg),

              // 1. Correo
              AppTarjeta(
                child: Form(
                  key: _formCorreo,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CampoTexto(
                        etiqueta: AppStrings.correoRegistrado,
                        ejemplo: AppStrings.ejemploCorreo,
                        icono: Icons.email_outlined,
                        controller: _correoController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.correoInstitucional,
                        habilitado: !estado.codigoEnviado,
                      ),
                      const SizedBox(height: AppSizes.md),
                      BotonPrimario(
                        texto: estado.codigoEnviado
                            ? AppStrings.codigoEnviado
                            : AppStrings.enviarCodigo,
                        onPressed: estado.codigoEnviado ? null : _enviarCodigo,
                        cargando: estado.cargando && !estado.codigoEnviado,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // 2. Código
              AppTarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.codigoRecibido, style: textos.labelMedium),
                    const SizedBox(height: AppSizes.md),
                    CampoCodigo(
                      longitud: CodigoVerificacionService.longitudCodigo,
                      habilitado: estado.codigoEnviado,
                      onChanged: (codigo) => _codigo = codigo,
                    ),
                    if (estado.codigoDePrueba != null) ...[
                      const SizedBox(height: AppSizes.md),
                      Center(
                        child: Text(
                          AppStrings.codigoDePrueba(estado.codigoDePrueba!),
                          style: textos.bodySmall,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // 3. Nueva contraseña
              AppTarjeta(
                child: Form(
                  key: _formContrasena,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CampoContrasena(
                        etiqueta: AppStrings.nuevaContrasena,
                        ejemplo: AppStrings.ejemploNuevaContrasena,
                        controller: _contrasenaController,
                        validator: Validators.contrasenaNueva,
                        habilitado: estado.codigoEnviado,
                      ),
                      const SizedBox(height: AppSizes.md),
                      CampoContrasena(
                        etiqueta: AppStrings.confirmarContrasena,
                        ejemplo: AppStrings.ejemploConfirmarContrasena,
                        controller: _confirmarController,
                        validator: Validators.confirmarContrasena(
                          () => _contrasenaController.text,
                        ),
                        habilitado: estado.codigoEnviado,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              BotonPrimario(
                texto: AppStrings.restablecerContrasena,
                onPressed: estado.codigoEnviado ? _restablecerContrasena : null,
                cargando: estado.cargando && estado.codigoEnviado,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
