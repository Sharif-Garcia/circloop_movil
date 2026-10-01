import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_colors.dart';
import '../../widgets/auth/fondo_eco.dart';
import '../../models/carrera.dart';
import '../../models/datos_registro.dart';
import '../../models/usuario.dart';
import '../../providers/carreras_provider.dart';
import '../../providers/registro_provider.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/validators.dart';
import '../../widgets/botones/boton_primario.dart';
import '../../widgets/botones/boton_volver.dart';
import '../../widgets/botones/enlace_texto.dart';
import '../../widgets/comunes/app_mensaje.dart';
import '../../widgets/comunes/dialogo_exito.dart';
import '../../widgets/comunes/encabezado_seccion.dart';
import '../../widgets/formularios/campo_contrasena.dart';
import '../../widgets/formularios/campo_selector.dart';
import '../../widgets/formularios/campo_texto.dart';
import '../../widgets/formularios/casilla_aceptacion.dart';

class RegistroScreen extends ConsumerStatefulWidget {
  const RegistroScreen({super.key});

  @override
  ConsumerState<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends ConsumerState<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarController = TextEditingController();

  Carrera? _carrera;

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  void _crearCuenta() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(registroProvider.notifier)
        .registrar(
          DatosRegistro(
            nombres: _nombresController.text.trim(),
            apellidos: _apellidosController.text.trim(),
            correoInstitucional: _correoController.text.trim(),
            contrasena: _contrasenaController.text,
            carreraId: _carrera!.id,
          ),
        );
  }

  void _volverAlLogin() => Navigator.pop(context);

  void _escucharRegistro(
    AsyncValue<Usuario?>? anterior,
    AsyncValue<Usuario?> actual,
  ) {
    actual.whenOrNull(
      data: (usuario) {
        if (usuario == null) return;
        mostrarDialogoExito(
          context,
          titulo: AppStrings.tituloCuentaCreada,
          mensaje: AppStrings.mensajeCuentaCreada(usuario.nombres),
          textoBoton: AppStrings.irAlLogin,
          alAceptar: _volverAlLogin,
        );
      },
      error: (error, _) => AppMensaje.error(context, error.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registro = ref.watch(registroProvider);
    ref.listen(registroProvider, _escucharRegistro);

    return FondoEco(
      child: Scaffold(
        backgroundColor: AppColors.transparente,
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
                    titulo: AppStrings.tituloRegistro,
                    subtitulo: AppStrings.subtituloRegistro,
                  ),
                  const SizedBox(height: AppSizes.lg),

                  CampoTexto(
                    etiqueta: AppStrings.nombres,
                    ejemplo: AppStrings.ejemploNombres,
                    icono: Icons.person_outline,
                    controller: _nombresController,
                    keyboardType: TextInputType.name,
                    validator: Validators.nombre,
                  ),
                  const SizedBox(height: AppSizes.md),

                  CampoTexto(
                    etiqueta: AppStrings.apellidos,
                    ejemplo: AppStrings.ejemploApellidos,
                    icono: Icons.person_outline,
                    controller: _apellidosController,
                    keyboardType: TextInputType.name,
                    validator: Validators.nombre,
                  ),
                  const SizedBox(height: AppSizes.md),

                  CampoTexto(
                    etiqueta: AppStrings.correoInstitucional,
                    ejemplo: AppStrings.ejemploCorreo,
                    icono: Icons.email_outlined,
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.correoInstitucional,
                  ),
                  const SizedBox(height: AppSizes.md),

                  CampoContrasena(
                    ejemplo: AppStrings.ejemploContrasenaRegistro,
                    controller: _contrasenaController,
                    validator: Validators.contrasenaNueva,
                  ),
                  const SizedBox(height: AppSizes.md),

                  CampoContrasena(
                    etiqueta: AppStrings.confirmarContrasenaRegistro,
                    ejemplo: AppStrings.ejemploConfirmarContrasena,
                    controller: _confirmarController,
                    validator: Validators.confirmarContrasena(
                      () => _contrasenaController.text,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),

                  _campoCarrera(),
                  const SizedBox(height: AppSizes.md),

                  CasillaAceptacion(
                    texto: AppStrings.aceptoTerminos,
                    validator: Validators.aceptarTerminos,
                  ),
                  const SizedBox(height: AppSizes.lg),

                  BotonPrimario(
                    texto: AppStrings.crearCuenta,
                    onPressed: _crearCuenta,
                    cargando: registro.isLoading,
                  ),
                  const SizedBox(height: AppSizes.md),

                  EnlaceTexto(
                    texto: AppStrings.yaTienesCuenta,
                    accion: AppStrings.iniciarSesion,
                    onPressed: _volverAlLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoCarrera() {
    final carreras = ref.watch(carrerasProvider);

    return CampoSelector<Carrera>(
      etiqueta: AppStrings.carrera,
      ejemplo: carreras.when(
        data: (_) => AppStrings.ejemploCarrera,
        loading: () => AppStrings.cargandoCarreras,
        error: (_, _) => AppStrings.errorCarreras,
      ),
      icono: Icons.school_outlined,
      opciones: carreras.value ?? const [],
      textoOpcion: (carrera) => carrera.nombre,
      valor: _carrera,
      habilitado: carreras.hasValue,
      onChanged: (carrera) => setState(() => _carrera = carrera),
      validator: Validators.seleccionRequerida(AppStrings.seleccionaCarrera),
    );
  }
}
