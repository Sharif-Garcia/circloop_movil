import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Fila de chips con desplazamiento horizontal para elegir UNA opción
/// (filtros). Si se indica [textoTodos], el primer chip representa "sin
/// filtro" y selecciona `null`.
class SelectorChips<T> extends StatelessWidget {
  final List<T> opciones;
  final String Function(T opcion) textoOpcion;
  final T? seleccion;
  final ValueChanged<T?> onChanged;
  final String? textoTodos;

  const SelectorChips({
    super.key,
    required this.opciones,
    required this.textoOpcion,
    required this.seleccion,
    required this.onChanged,
    this.textoTodos,
  });

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      if (textoTodos != null)
        _chip(textoTodos!, seleccion == null, () => onChanged(null)),
      for (final opcion in opciones)
        _chip(
          textoOpcion(opcion),
          seleccion == opcion,
          () => onChanged(opcion),
        ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSizes.sm),
            chips[i],
          ],
        ],
      ),
    );
  }

  Widget _chip(String texto, bool activo, VoidCallback alElegir) {
    return ChoiceChip(
      label: Text(texto),
      selected: activo,
      showCheckmark: false,
      // Tamaño y peso vienen de chipTheme; aquí solo el color por estado
      labelStyle: TextStyle(
        color: activo ? AppColors.white : AppColors.textPrimary,
      ),
      onSelected: (_) => alElegir(),
    );
  }
}
