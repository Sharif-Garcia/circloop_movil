import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_sizes.dart';

/// Campo de formulario con su etiqueta encima. Bordes, relleno y colores
/// se heredan de `inputDecorationTheme` en AppTheme.
class CampoTexto extends StatelessWidget {
  final String etiqueta;
  final String? ejemplo;
  final IconData? icono;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool ocultarTexto;
  final bool habilitado;
  final Widget? sufijo;

  /// Líneas visibles (más de 1 para mensajes o descripciones).
  final int lineas;

  /// Restricciones de lo que se puede escribir, por ejemplo
  /// `[FilteringTextInputFormatter.digitsOnly]` para solo números.
  final List<TextInputFormatter>? formateadores;

  const CampoTexto({
    super.key,
    required this.etiqueta,
    this.ejemplo,
    this.icono,
    this.controller,
    this.validator,
    this.keyboardType,
    this.ocultarTexto = false,
    this.habilitado = true,
    this.sufijo,
    this.lineas = 1,
    this.formateadores,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppSizes.sm),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: ocultarTexto,
          enabled: habilitado,
          maxLines: lineas,
          inputFormatters: formateadores,
          decoration: InputDecoration(
            hintText: ejemplo,
            prefixIcon: icono != null ? Icon(icono) : null,
            suffixIcon: sufijo,
            contentPadding: lineas > 1
                ? const EdgeInsets.all(AppSizes.md)
                : null,
          ),
        ),
      ],
    );
  }
}
