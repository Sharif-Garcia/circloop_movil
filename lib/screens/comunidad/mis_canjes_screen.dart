import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/canje.dart';
import '../../models/premio.dart';
import '../../providers/canjes_provider.dart';
import '../../utils/app_categorias_premio.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../../widgets/botones/boton_volver.dart';
import '../../widgets/comunes/codigo_qr.dart';
import '../../widgets/comunes/encabezado_seccion.dart';
import '../../widgets/comunes/estado_vacio.dart';
import '../../widgets/comunes/etiqueta.dart';
import '../../widgets/comunes/item_lista.dart';

/// Premios canjeados por el usuario. Al tocar uno pendiente se muestra su
/// código y QR para reclamarlo en el establecimiento.
class MisCanjesScreen extends ConsumerWidget {
  const MisCanjesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canjes = ref.watch(canjesUsuarioProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.lg),
          children: [
            const BotonVolver(),
            const SizedBox(height: AppSizes.md),
            const EncabezadoSeccion(
              titulo: AppStrings.misCanjes,
              subtitulo: AppStrings.subtituloMisCanjes,
            ),
            const SizedBox(height: AppSizes.lg),
            ...canjes.when(
              data: (lista) => lista.isEmpty
                  ? [
                      const EstadoVacio(
                        icono: Icons.card_giftcard_outlined,
                        titulo: AppStrings.sinCanjes,
                        mensaje: AppStrings.sinCanjesMensaje,
                      ),
                    ]
                  : [
                      for (final item in lista)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.sm),
                          child: _ItemCanje(
                            canje: item.canje,
                            premio: item.premio,
                          ),
                        ),
                    ],
              loading: () => [const Center(child: CircularProgressIndicator())],
              error: (_, _) => [
                const EstadoVacio(
                  icono: Icons.cloud_off_outlined,
                  titulo: AppStrings.errorCargar,
                  mensaje: AppStrings.errorGeneral,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCanje extends StatelessWidget {
  final Canje canje;
  final Premio? premio;

  const _ItemCanje({required this.canje, required this.premio});

  void _mostrarCodigo(BuildContext context, String titulo) {
    final textos = Theme.of(context).textTheme;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.lg,
            0,
            AppSizes.lg,
            AppSizes.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titulo,
                style: textos.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                AppStrings.subtituloMisCanjes,
                style: textos.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.lg),
              CodigoQr(codigo: canje.codigo),
              const SizedBox(height: AppSizes.md),
              Text(AppStrings.codigoCanje, style: textos.bodySmall),
              SelectableText(
                canje.codigo,
                style: textos.titleLarge?.copyWith(letterSpacing: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoria = AppCategoriaPremio.porClave(premio?.categoria ?? '');
    final titulo = premio?.titulo ?? AppStrings.premioNoDisponible;

    return ItemLista(
      icono: categoria.icono,
      color: categoria.color,
      titulo: titulo,
      subtitulo: '${Formatos.fechaRelativa(canje.fecha)} • ${canje.codigo}',
      extremo: canje.estaPendiente
          ? const Etiqueta(
              texto: AppStrings.porReclamar,
              color: AppColors.tertiary,
            )
          : const Etiqueta(
              texto: AppStrings.reclamado,
              color: AppColors.success,
            ),
      onTap: canje.estaPendiente ? () => _mostrarCodigo(context, titulo) : null,
    );
  }
}
