import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/nivel_eco.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progreso_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/formatos.dart';
import '../../widgets/botones/boton_volver.dart';
import '../../widgets/comunes/app_tarjeta.dart';
import '../../widgets/comunes/codigo_qr.dart';
import '../../widgets/comunes/encabezado_seccion.dart';
import '../../widgets/comunes/tarjeta_aviso.dart';

/// QR personal del usuario (Código Eco-Identificador). El operador lo
/// escanea en la estación para registrar la entrega a su nombre.
class CodigoQrScreen extends ConsumerWidget {
  const CodigoQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authProvider).value;
    final codigo = ref.watch(ecoIdentificadorProvider).value;
    if (usuario == null) return const Scaffold();

    final textos = Theme.of(context).textTheme;
    final nivel = NivelEco.paraXp(usuario.puntosHistoricos);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.lg),
          children: [
            const BotonVolver(),
            const SizedBox(height: AppSizes.md),
            const EncabezadoSeccion(
              titulo: AppStrings.codigoEcoIdentificador,
              subtitulo: AppStrings.acercarCodigo,
            ),
            const SizedBox(height: AppSizes.lg),
            AppTarjeta(
              child: Column(
                children: [
                  CodigoQr(codigo: codigo),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    '${usuario.nombres} ${usuario.apellidos}',
                    style: textos.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (codigo != null)
                    SelectableText(
                      codigo,
                      style: textos.labelMedium?.copyWith(letterSpacing: 1.5),
                    ),
                  const Divider(height: AppSizes.xl, color: AppColors.border),
                  Row(
                    children: [
                      Expanded(
                        child: _DatoEtiquetado(
                          etiqueta: AppStrings.tuBalance,
                          valor: AppStrings.puntos(
                            Formatos.entero(usuario.puntosTotales),
                          ),
                          color: AppColors.tertiary,
                        ),
                      ),
                      Expanded(
                        child: _DatoEtiquetado(
                          etiqueta: AppStrings.tuNivel,
                          valor: nivel.nombre,
                          alinearAlFinal: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            const TarjetaAviso(
              titulo: AppStrings.comoReciclarQr,
              lineas: AppStrings.pasosQr,
            ),
          ],
        ),
      ),
    );
  }
}

/// Etiqueta pequeña en mayúsculas con un valor destacado debajo.
class _DatoEtiquetado extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final Color? color;
  final bool alinearAlFinal;

  const _DatoEtiquetado({
    required this.etiqueta,
    required this.valor,
    this.color,
    this.alinearAlFinal = false,
  });

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: alinearAlFinal
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: textos.bodySmall),
        Text(valor, style: textos.titleSmall?.copyWith(color: color)),
      ],
    );
  }
}
