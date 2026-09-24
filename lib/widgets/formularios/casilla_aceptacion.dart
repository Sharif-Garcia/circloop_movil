import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Casilla de verificación con texto (por ejemplo, aceptar términos).
/// Participa en la validación del `Form` como cualquier otro campo.
class CasillaAceptacion extends FormField<bool> {
  CasillaAceptacion({
    super.key,
    required String texto,
    super.validator,
    ValueChanged<bool>? onChanged,
  }) : super(
         initialValue: false,
         builder: (campo) {
           final textos = Theme.of(campo.context).textTheme;

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               InkWell(
                 onTap: () {
                   final nuevo = !(campo.value ?? false);
                   campo.didChange(nuevo);
                   onChanged?.call(nuevo);
                 },
                 child: Row(
                   children: [
                     Checkbox(
                       value: campo.value ?? false,
                       onChanged: (valor) {
                         campo.didChange(valor ?? false);
                         onChanged?.call(valor ?? false);
                       },
                     ),
                     Expanded(child: Text(texto, style: textos.bodySmall)),
                   ],
                 ),
               ),
               if (campo.hasError)
                 Padding(
                   padding: const EdgeInsets.only(left: AppSizes.md),
                   child: Text(
                     campo.errorText!,
                     style: textos.bodySmall?.copyWith(color: AppColors.error),
                   ),
                 ),
             ],
           );
         },
       );
}
