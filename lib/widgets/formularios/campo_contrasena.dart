import 'package:flutter/material.dart';

import '../../utils/app_strings.dart';
import 'package:circloop_movil/widgets/formularios/campo_texto.dart';

/// Campo de contraseña con botón para mostrar u ocultar el texto.
class CampoContrasena extends StatefulWidget {
  final String etiqueta;
  final String ejemplo;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool habilitado;

  const CampoContrasena({
    super.key,
    this.etiqueta = AppStrings.contrasena,
    this.ejemplo = AppStrings.ejemploContrasena,
    this.controller,
    this.validator,
    this.habilitado = true,
  });

  @override
  State<CampoContrasena> createState() => _CampoContrasenaState();
}

class _CampoContrasenaState extends State<CampoContrasena> {
  bool _oculta = true;

  @override
  Widget build(BuildContext context) {
    return CampoTexto(
      etiqueta: widget.etiqueta,
      ejemplo: widget.ejemplo,
      icono: Icons.lock_outline,
      controller: widget.controller,
      validator: widget.validator,
      ocultarTexto: _oculta,
      habilitado: widget.habilitado,
      sufijo: IconButton(
        onPressed: widget.habilitado
            ? () => setState(() => _oculta = !_oculta)
            : null,
        icon: Icon(
          _oculta ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        ),
      ),
    );
  }
}
