import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';

/// Casillas para escribir un código numérico, un dígito por casilla.
/// El foco avanza solo al escribir y retrocede al borrar.
class CampoCodigo extends StatefulWidget {
  final int longitud;
  final bool habilitado;
  final ValueChanged<String> onChanged;

  const CampoCodigo({
    super.key,
    required this.longitud,
    required this.onChanged,
    this.habilitado = true,
  });

  @override
  State<CampoCodigo> createState() => _CampoCodigoState();
}

class _CampoCodigoState extends State<CampoCodigo> {
  late final List<TextEditingController> _controllers = List.generate(
    widget.longitud,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _focos = List.generate(
    widget.longitud,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final foco in _focos) {
      foco.dispose();
    }
    super.dispose();
  }

  void _alCambiar(int index, String valor) {
    if (valor.isNotEmpty && index < widget.longitud - 1) {
      _focos[index + 1].requestFocus();
    } else if (valor.isEmpty && index > 0) {
      _focos[index - 1].requestFocus();
    }

    widget.onChanged(_controllers.map((c) => c.text).join());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.longitud, (index) {
        return SizedBox(
          width: AppSizes.casillaCodigo,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focos[index],
            enabled: widget.habilitado,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            style: const TextStyle(
              fontSize: AppSizes.textLg,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
            decoration: const InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.symmetric(vertical: AppSizes.md),
            ),
            onChanged: (valor) => _alCambiar(index, valor),
          ),
        );
      }),
    );
  }
}
