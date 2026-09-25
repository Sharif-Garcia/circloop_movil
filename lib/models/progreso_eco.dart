import 'entrega.dart';
import 'nivel_eco.dart';
import 'usuario.dart';

/// Resumen del avance ecológico de un usuario, calculado a partir de sus
/// entregas. Lo usan el impacto del inicio, el perfil y las insignias.
class ProgresoEco {
  final int cantidadEntregas;
  final double pesoKg;
  final double co2EvitadoKg;

  /// Cantidad de entregas por material (clave de `AppMaterial`).
  final Map<String, int> entregasPorMaterial;

  /// Puntos ganados con entregas del mes en curso.
  final int puntosMes;
  final NivelEco nivel;

  const ProgresoEco({
    required this.cantidadEntregas,
    required this.pesoKg,
    required this.co2EvitadoKg,
    required this.entregasPorMaterial,
    required this.nivel,
    this.puntosMes = 0,
  });

  /// [ahora] define cuál es el mes en curso (por defecto, la fecha actual).
  factory ProgresoEco.desde(
    Usuario usuario,
    List<Entrega> entregas, {
    DateTime? ahora,
  }) {
    final hoy = ahora ?? DateTime.now();
    final porMaterial = <String, int>{};
    var peso = 0.0;
    var co2 = 0.0;
    var puntosMes = 0;

    for (final entrega in entregas) {
      peso += entrega.pesoKg;
      co2 += entrega.co2EvitadoKg;
      porMaterial[entrega.material] = (porMaterial[entrega.material] ?? 0) + 1;
      if (entrega.fecha.year == hoy.year && entrega.fecha.month == hoy.month) {
        puntosMes += entrega.puntos;
      }
    }

    return ProgresoEco(
      cantidadEntregas: entregas.length,
      pesoKg: peso,
      co2EvitadoKg: co2,
      entregasPorMaterial: porMaterial,
      puntosMes: puntosMes,
      nivel: NivelEco.paraXp(usuario.puntosHistoricos),
    );
  }
}
