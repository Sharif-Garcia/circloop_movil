import 'package:flutter/material.dart';

import '../../utils/app_sizes.dart';

/// Lista desplegable con su etiqueta encima. Mismo estilo que [CampoTexto]
/// (heredado de `inputDecorationTheme`).
class CampoSelector<T> extends StatelessWidget {
  final String etiqueta;
  final String ejemplo;
  final IconData? icono;
  final List<T> opciones;
  final String Function(T opcion) textoOpcion;
  final T? valor;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final bool habilitado;

  const CampoSelector({
    super.key,
    required this.etiqueta,
    required this.ejemplo,
    required this.opciones,
    required this.textoOpcion,
    required this.onChanged,
    this.icono,
    this.valor,
    this.validator,
    this.habilitado = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppSizes.sm),
        DropdownButtonFormField<T>(
          initialValue: valor,
          isExpanded: true,
          hint: Text(ejemplo),
          validator: validator,
          onChanged: habilitado ? onChanged : null,
          decoration: InputDecoration(
            prefixIcon: icono != null ? Icon(icono) : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSizes.md,
              horizontal: AppSizes.md,
            ),
          ),
          items: opciones
              .map(
                (opcion) => DropdownMenuItem<T>(
                  value: opcion,
                  child: Text(
                    textoOpcion(opcion),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
