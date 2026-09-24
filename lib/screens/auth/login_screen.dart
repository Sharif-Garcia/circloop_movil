import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/validators.dart';
import '../../widgets/comunes/app_mensaje.dart';
import '../../widgets/comunes/app_tarjeta.dart';
import '../../widgets/botones/boton_primario.dart';
import '../../widgets/formularios/campo_contrasena.dart';
import '../../widgets/formularios/campo_texto.dart';
import '../../widgets/auth/encabezado_auth.dart';
import '../inicio/inicio_rol_screen.dart';
import '../../widgets/botones/enlace_texto.dart';
import 'recuperar_contrasena_screen.dart';
import 'registro_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(authProvider.notifier)
        .iniciarSesion(
          _correoController.text.trim(),
          _contrasenaController.text,
        );
  }

  void _irAInicio(Usuario usuario) {
    AppMensaje.exito(context, AppStrings.bienvenida(usuario.nombres));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InicioRolScreen()),
    );
  }

  void _abrir(Widget pantalla) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AsyncValue<Usuario?>>(authProvider, (previous, next) {
      next.whenOrNull(
        data: (usuario) {
          if (usuario != null) _irAInicio(usuario);
        },
        error: (error, _) => AppMensaje.error(context, error.toString()),
      );
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.xl),

                const EncabezadoAuth(
                  titulo: AppStrings.tituloLogin,
                  subtitulo: AppStrings.subtituloLogin,
                ),

                const SizedBox(height: AppSizes.xl),

                AppTarjeta(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CampoTexto(
                        etiqueta: AppStrings.correoInstitucional,
                        ejemplo: AppStrings.ejemploCorreo,
                        icono: Icons.email_outlined,
                        controller: _correoController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.correo,
                      ),

                      const SizedBox(height: AppSizes.md),

                      CampoContrasena(
                        controller: _contrasenaController,
                        validator: Validators.contrasena,
                      ),

                      const SizedBox(height: AppSizes.sm),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              _abrir(const RecuperarContrasenaScreen()),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text(AppStrings.olvidasteContrasena),
                        ),
                      ),

                      const SizedBox(height: AppSizes.md),

                      BotonPrimario(
                        texto: AppStrings.iniciarSesion,
                        onPressed: _iniciarSesion,
                        cargando: authState.isLoading,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.lg),

                EnlaceTexto(
                  texto: AppStrings.noTienesCuenta,
                  accion: AppStrings.registrate,
                  onPressed: () => _abrir(const RegistroScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
