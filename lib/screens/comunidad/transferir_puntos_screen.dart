import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/transferencia.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transferencia_provider.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../../utils/validators.dart';
import '../../widgets/botones/boton_primario.dart';
import '../../widgets/botones/boton_volver.dart';
import '../../widgets/comunes/app_mensaje.dart';
import '../../widgets/comunes/dialogo_confirmacion.dart';
import '../../widgets/comunes/dialogo_exito.dart';
import '../../widgets/comunes/encabezado_seccion.dart';
import '../../widgets/comunidad/tarjeta_puntos.dart';
import '../../widgets/formularios/campo_texto.dart';

/// Envío de puntos disponibles a otro miembro de la comunidad.
class TransferirPuntosScreen extends ConsumerStatefulWidget {
  const TransferirPuntosScreen({super.key});

  /// Largo máximo del mensaje opcional.
  static const int largoMaximoMensaje = 120;

  @override
  ConsumerState<TransferirPuntosScreen> createState() =>
      _TransferirPuntosScreenState();
}

class _TransferirPuntosScreenState
    extends ConsumerState<TransferirPuntosScreen> {
  final _formKey = GlobalKey<FormState>();

  final _correoController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _mensajeController = TextEditingController();

  @override
  void dispose() {
    _correoController.dispose();
    _cantidadController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }

  Future<void> _transferir(int disponibles) async {
    if (!_formKey.currentState!.validate()) return;

    final correo = _correoController.text.trim().toLowerCase();
    final puntos = int.parse(_cantidadController.text.trim());
    final mensaje = _mensajeController.text.trim();

    final confirmado = await mostrarDialogoConfirmacion(
      context,
      titulo: AppStrings.confirmarTransferenciaTitulo(Formatos.entero(puntos)),
      mensaje: AppStrings.confirmarTransferenciaMensaje(
        Formatos.entero(puntos),
        correo,
        Formatos.entero(disponibles - puntos),
      ),
    );
    if (!confirmado || !mounted) return;

    ref
        .read(transferirProvider.notifier)
        .transferir(
          correoDestino: correo,
          puntos: puntos,
          mensaje: mensaje.isEmpty ? null : mensaje,
        );
  }

  void _escucharTransferencia(
    AsyncValue<Transferencia?>? anterior,
    AsyncValue<Transferencia?> actual,
  ) {
    actual.whenOrNull(
      data: (transferencia) {
        if (transferencia == null) return;
        mostrarDialogoExito(
          context,
          titulo: AppStrings.transferenciaExitosaTitulo,
          mensaje: AppStrings.transferenciaExitosaMensaje(
            Formatos.entero(transferencia.puntos),
            _correoController.text.trim().toLowerCase(),
          ),
          textoBoton: AppStrings.entendido,
          alAceptar: () => Navigator.pop(context),
        );
      },
      error: (error, _) => AppMensaje.error(context, error.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ref.watch(authProvider).value;
    if (usuario == null) return const Scaffold();

    final estado = ref.watch(transferirProvider);
    ref.listen(transferirProvider, _escucharTransferencia);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BotonVolver(),
                const SizedBox(height: AppSizes.md),
                const EncabezadoSeccion(
                  titulo: AppStrings.transferirPuntos,
                  subtitulo: AppStrings.subtituloTransferir,
                ),
                const SizedBox(height: AppSizes.lg),
                TarjetaPuntos(
                  puntos: usuario.puntosTotales,
                  descripcion: AppStrings.disponiblesParaTransferir,
                ),
                const SizedBox(height: AppSizes.lg),
                CampoTexto(
                  etiqueta: AppStrings.correoDestinatario,
                  ejemplo: AppStrings.ejemploCorreo,
                  icono: Icons.alternate_email,
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.correoInstitucional,
                ),
                const SizedBox(height: AppSizes.md),
                CampoTexto(
                  etiqueta: AppStrings.cantidadPuntos,
                  ejemplo: AppStrings.ejemploCantidad,
                  icono: Icons.star_outline_rounded,
                  controller: _cantidadController,
                  keyboardType: TextInputType.number,
                  formateadores: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validators.cantidadPuntos(usuario.puntosTotales),
                ),
                const SizedBox(height: AppSizes.md),
                CampoTexto(
                  etiqueta: AppStrings.mensajeOpcional,
                  ejemplo: AppStrings.ejemploMensaje,
                  controller: _mensajeController,
                  lineas: 2,
                  validator: Validators.textoMaximo(
                    TransferirPuntosScreen.largoMaximoMensaje,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                BotonPrimario(
                  texto: AppStrings.transferirPuntos,
                  onPressed: () => _transferir(usuario.puntosTotales),
                  cargando: estado.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
