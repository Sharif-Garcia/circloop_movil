import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/entrega.dart';
import '../../models/progreso_eco.dart';
import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../providers/entregas_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_materiales.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../../widgets/comunes/estado_vacio.dart';
import '../../widgets/comunes/tarjeta_resumen.dart';
import '../../widgets/comunes/titulo_seccion.dart';
import '../../widgets/comunidad/item_entrega.dart';
import '../../widgets/formularios/selector_chips.dart';

/// Pestaña "Reciclaje" del rol comunidad: resumen de entregas, historial
/// filtrable por material y acceso al código QR personal.
class ReciclajeComunidadScreen extends ConsumerStatefulWidget {
  const ReciclajeComunidadScreen({super.key});

  @override
  ConsumerState<ReciclajeComunidadScreen> createState() =>
      _ReciclajeComunidadScreenState();
}

class _ReciclajeComunidadScreenState
    extends ConsumerState<ReciclajeComunidadScreen> {
  /// Clave del material filtrado; `null` = todos.
  String? _material;

  @override
  Widget build(BuildContext context) {
    final usuario = ref.watch(authProvider).value;
    if (usuario == null) return const SizedBox.shrink();

    final entregas = ref.watch(entregasUsuarioProvider);

    // El botón flotante "Mi Código QR" lo pone el panel (ver
    // PanelComunidadScreen), junto con la barra superior y la navegación.
    return RefreshIndicator(
      onRefresh: () => ref.refresh(entregasUsuarioProvider.future),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.lg,
          AppSizes.lg,
          // Espacio para que el botón flotante no tape la última entrega
          AppSizes.xxl * 2,
        ),
        children: entregas.when(
          data: (lista) => _contenido(usuario, lista),
          loading: () => [const Center(child: CircularProgressIndicator())],
          error: (_, _) => [
            const EstadoVacio(
              icono: Icons.cloud_off_outlined,
              titulo: AppStrings.errorCargar,
              mensaje: AppStrings.errorGeneral,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _contenido(Usuario usuario, List<Entrega> entregas) {
    final progreso = ProgresoEco.desde(usuario, entregas);
    final filtradas = _material == null
        ? entregas
        : entregas.where((e) => e.material == _material).toList();

    return [
      TarjetaResumen(
        datos: [
          DatoResumen(
            valor: Formatos.entero(progreso.cantidadEntregas),
            descripcion: AppStrings.entregas,
          ),
          DatoResumen(
            valor: Formatos.kilos(progreso.pesoKg),
            descripcion: AppStrings.pesoTotal,
          ),
          DatoResumen(
            valor: AppStrings.puntosGanados(progreso.puntosMes),
            descripcion: AppStrings.esteMes,
            color: AppColors.tertiary,
          ),
        ],
      ),
      const SizedBox(height: AppSizes.lg),
      const TituloSeccion(titulo: AppStrings.misEntregas),
      const SizedBox(height: AppSizes.sm),
      SelectorChips<String>(
        opciones: AppMaterial.claves,
        textoOpcion: (clave) => AppMaterial.porClave(clave).nombreCorto,
        seleccion: _material,
        textoTodos: AppStrings.todos,
        onChanged: (clave) => setState(() => _material = clave),
      ),
      const SizedBox(height: AppSizes.md),
      if (entregas.isEmpty)
        const EstadoVacio(
          icono: Icons.recycling,
          titulo: AppStrings.sinEntregas,
          mensaje: AppStrings.sinEntregasMensaje,
        )
      else if (filtradas.isEmpty)
        EstadoVacio(
          icono: AppMaterial.porClave(_material!).icono,
          titulo: AppStrings.sinEntregasMaterial,
          mensaje: AppStrings.sinEntregasMaterialMensaje(
            AppMaterial.porClave(_material!).nombreCorto.toLowerCase(),
          ),
        )
      else
        for (final entrega in filtradas)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: ItemEntrega(entrega: entrega),
          ),
    ];
  }
}
