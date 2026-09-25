import 'app_strings.dart';

/// Formatos de números y fechas para mostrar en pantalla (es-CO).
class Formatos {
  static const List<String> _meses = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  /// 1250 → "1.250"
  static String entero(int valor) {
    final texto = valor.abs().toString();
    final grupos = <String>[];

    for (var fin = texto.length; fin > 0; fin -= 3) {
      grupos.insert(0, texto.substring(fin - 3 < 0 ? 0 : fin - 3, fin));
    }

    return '${valor < 0 ? '-' : ''}${grupos.join('.')}';
  }

  /// 14.5 → "14,5 kg"; 4.0 → "4 kg"
  static String kilos(double valor) => '${decimal(valor)} kg';

  /// 14.5 → "14,5"; 4.0 → "4"
  static String decimal(double valor) {
    final redondeado = (valor * 10).round() / 10;
    final texto = redondeado == redondeado.roundToDouble()
        ? redondeado.toInt().toString()
        : redondeado.toStringAsFixed(1);
    return texto.replaceAll('.', ',');
  }

  /// "Hoy, 10:45 AM", "Ayer, 4:20 PM" o "18 Sep, 11:15 AM".
  static String fechaRelativa(DateTime fecha, {DateTime? ahora}) {
    final referencia = ahora ?? DateTime.now();
    final dia = DateTime(fecha.year, fecha.month, fecha.day);
    final hoy = DateTime(referencia.year, referencia.month, referencia.day);
    final diferencia = hoy.difference(dia).inDays;

    final String cuando;
    if (diferencia == 0) {
      cuando = AppStrings.hoy;
    } else if (diferencia == 1) {
      cuando = AppStrings.ayer;
    } else {
      cuando = '${fecha.day} ${_meses[fecha.month - 1]}';
    }

    return '$cuando, ${hora(fecha)}';
  }

  /// 16:20 → "4:20 PM"
  static String hora(DateTime fecha) {
    final hora12 = fecha.hour % 12 == 0 ? 12 : fecha.hour % 12;
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final periodo = fecha.hour < 12 ? 'AM' : 'PM';
    return '$hora12:$minutos $periodo';
  }
}
