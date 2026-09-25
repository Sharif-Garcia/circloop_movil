import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/carrera.dart';
import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../providers/carreras_provider.dart';
import '../../providers/editar_perfil_provider.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/validators.dart';
import '../../widgets/botones/boton_primario.dart';
import '../../widgets/botones/boton_volver.dart';
import '../../widgets/comunes/app_mensaje.dart';
import '../../widgets/comunes/encabezado_seccion.dart';
import '../../widgets/formularios/campo_selector.dart';
import '../../widgets/formularios/campo_texto.dart';

/// Edición de los datos del perfil (nombres, apellidos y, si el usuario
/// tiene una, su carrera). Sirve para cualquier rol.
class EditarPerfilScreen extends ConsumerStatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  ConsumerState<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends ConsumerState<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();

  late final Usuario _usuario = ref.read(authProvider).value!;
  late final _nombresController = TextEditingController(text: _usuario.nombres);
  late final _apellidosController = TextEditingController(
    text: _usuario.apellidos,
  );
  late int? _carreraId = _usuario.carreraId;

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(editarPerfilProvider.notifier)
        .guardar(
          nombres: _nombresController.text.trim(),
          apellidos: _apellidosController.text.trim(),
          carreraId: _carreraId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(editarPerfilProvider);

    ref.listen(editarPerfilProvider, (anterior, actual) {
      actual.whenOrNull(
        data: (usuario) {
          if (usuario == null) return;
          AppMensaje.exito(context, AppStrings.perfilActualizado);
          Navigator.pop(context);
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
                const BotonVolver(),
                const SizedBox(height: AppSizes.md),
                const EncabezadoSeccion(
                  titulo: AppStrings.tituloEditarPerfil,
                  subtitulo: AppStrings.subtituloEditarPerfil,
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
                // La carrera solo aplica a quien ya tiene una (comunidad)
                if (_usuario.carreraId != null) ...[
                  const SizedBox(height: AppSizes.md),
                  _campoCarrera(),
                ],
                const SizedBox(height: AppSizes.xl),
                BotonPrimario(
                  texto: AppStrings.guardarCambios,
                  onPressed: _guardar,
                  cargando: estado.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoCarrera() {
    final carreras = ref.watch(carrerasProvider);
    final lista = carreras.value ?? const <Carrera>[];

    return CampoSelector<Carrera>(
      // Se vuelve a crear cuando llegan las carreras, para mostrar la actual
      key: ValueKey(lista.length),
      etiqueta: AppStrings.carrera,
      ejemplo: carreras.isLoading
          ? AppStrings.cargandoCarreras
          : AppStrings.ejemploCarrera,
      icono: Icons.school_outlined,
      opciones: lista,
      textoOpcion: (carrera) => carrera.nombre,
      valor: lista.where((c) => c.id == _carreraId).firstOrNull,
      habilitado: carreras.hasValue,
      onChanged: (carrera) => setState(() => _carreraId = carrera?.id),
      validator: Validators.seleccionRequerida(AppStrings.seleccionaCarrera),
    );
  }
}
