import 'package:flutter/material.dart';

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
          decoration: InputDecoration(
            hintText: ejemplo,
            prefixIcon: icono != null ? Icon(icono) : null,
            suffixIcon: sufijo,
          ),
        ),
      ],
    );
  }
}
