import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/canje.dart';
import '../../models/premio.dart';
import '../../providers/auth_provider.dart';
import '../../providers/canjes_provider.dart';
import '../../utils/app_categorias_premio.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../../widgets/botones/boton_secundario.dart';
import '../../widgets/comunes/app_mensaje.dart';
import '../../widgets/comunes/dialogo_confirmacion.dart';
import '../../widgets/comunes/dialogo_exito.dart';
import '../../widgets/comunes/estado_vacio.dart';
import '../../widgets/comunes/etiqueta.dart';
import '../../widgets/comunes/titulo_seccion.dart';
import '../../widgets/comunidad/tarjeta_premio.dart';
import '../../widgets/comunidad/tarjeta_puntos.dart';
import '../../widgets/formularios/selector_chips.dart';
import 'mis_canjes_screen.dart';
import 'transferir_puntos_screen.dart';

/// Pestaña "Canjes" del rol comunidad: puntos disponibles, catálogo de
/// premios filtrable por categoría y canje con confirmación.
class CanjesComunidadScreen extends ConsumerStatefulWidget {
  const CanjesComunidadScreen({super.key});

  @override
  ConsumerState<CanjesComunidadScreen> createState() =>
      _CanjesComunidadScreenState();
}

class _CanjesComunidadScreenState extends ConsumerState<CanjesComunidadScreen> {
  /// Clave de la categoría filtrada; `null` = todas.
  String? _categoria;

  /// Premio que se está canjeando (para mostrar la carga solo en su botón).
  Premio? _premioEnCanje;

  Future<void> _canjear(Premio premio) async {
    final usuario = ref.read(authProvider).value;
    if (usuario == null) return;

    final confirmado = await mostrarDialogoConfirmacion(
      context,
      titulo: AppStrings.confirmarCanjeTitulo(premio.titulo),
      mensaje: AppStrings.confirmarCanjeMensaje(
        Formatos.entero(premio.costoPuntos),
        Formatos.entero(usuario.puntosTotales - premio.costoPuntos),
      ),
    );
    if (!confirmado || !mounted) return;

    setState(() => _premioEnCanje = premio);
    await ref.read(canjearProvider.notifier).canjear(premio);
  }

  void _abrirTransferir() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransferirPuntosScreen()),
    );
  }

  void _abrirMisCanjes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MisCanjesScreen()),
    );
  }

  void _escucharCanje(AsyncValue<Canje?>? anterior, AsyncValue<Canje?> actual) {
    if (actual.isLoading) return;
    final premio = _premioEnCanje;
    setState(() => _premioEnCanje = null);

    actual.whenOrNull(
      data: (canje) {
        if (canje == null || premio == null) return;
        mostrarDialogoExito(
          context,
          titulo: AppStrings.canjeExitosoTitulo,
          mensaje: AppStrings.canjeExitosoMensaje(premio.titulo, canje.codigo),
          textoBoton: AppStrings.entendido,
        );
      },
      error: (error, _) => AppMensaje.error(context, error.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ref.watch(authProvider).value;
    if (usuario == null) return const SizedBox.shrink();

    final premios = ref.watch(premiosProvider);
    ref.listen(canjearProvider, _escucharCanje);

    return ListView(
      padding: const EdgeInsets.all(AppSizes.lg),
      children: premios.when(
        data: (lista) => _contenido(usuario.puntosTotales, lista),
        loading: () => [const Center(child: CircularProgressIndicator())],
        error: (_, _) => [
          const EstadoVacio(
            icono: Icons.cloud_off_outlined,
            titulo: AppStrings.errorCargar,
            mensaje: AppStrings.errorGeneral,
          ),
        ],
      ),
    );
  }

  List<Widget> _contenido(int puntos, List<Premio> premios) {
    final filtrados = _categoria == null
        ? premios
        : premios.where((p) => p.categoria == _categoria).toList();

    return [
      TarjetaPuntos(
        puntos: puntos,
        descripcion: AppStrings.paraCanjear,
        extremo: Etiqueta(
          texto: AppStrings.elegibles(
            premios.where((p) => !p.agotado && p.costoPuntos <= puntos).length,
          ),
          icono: Icons.check_circle_outline,
          color: AppColors.success,
        ),
      ),
      const SizedBox(height: AppSizes.sm),
      BotonSecundario(
        texto: AppStrings.transferirPuntos,
        icono: Icons.send_outlined,
        onPressed: _abrirTransferir,
      ),
      const SizedBox(height: AppSizes.lg),
      TituloSeccion(
        titulo: AppStrings.catalogo,
        accion: AppStrings.misCanjes,
        onAccion: _abrirMisCanjes,
      ),
      const SizedBox(height: AppSizes.sm),
      SelectorChips<String>(
        opciones: AppCategoriaPremio.claves,
        textoOpcion: (clave) => AppCategoriaPremio.porClave(clave).nombre,
        seleccion: _categoria,
        textoTodos: AppStrings.todo,
        onChanged: (clave) => setState(() => _categoria = clave),
      ),
      const SizedBox(height: AppSizes.md),
      if (filtrados.isEmpty)
        const EstadoVacio(
          icono: Icons.card_giftcard_outlined,
          titulo: AppStrings.sinPremios,
          mensaje: AppStrings.sinPremiosMensaje,
        )
      else
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtrados.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.md,
            mainAxisSpacing: AppSizes.md,
            mainAxisExtent: AppSizes.tarjetaPremioAlto,
          ),
          itemBuilder: (context, indice) {
            final premio = filtrados[indice];
            return TarjetaPremio(
              premio: premio,
              puntosDisponibles: puntos,
              cargando: _premioEnCanje?.id == premio.id,
              onCanjear: () => _canjear(premio),
            );
          },
        ),
    ];
  }
}
