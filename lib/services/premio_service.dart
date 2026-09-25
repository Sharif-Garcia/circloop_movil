import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/premio.dart';

class PremioService {
  // Mientras no exista un backend, el stock que cambia con los canjes se
  // guarda en memoria (se pierde al cerrar la app).
  static final Map<int, int> _stockActualizado = {};

  @visibleForTesting
  static void reiniciarDatosEnMemoria() => _stockActualizado.clear();

  /// Premios activos del catálogo, del más barato al más caro.
  Future<List<Premio>> obtenerPremios() async {
    // TODO: cuando exista el backend, pedir el catálogo (con imagenUrl,
    // stock y activo) a la API. El resto de la app no cambia.
    final String respuesta = await rootBundle.loadString(
      'assets/data/premios.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return datos
        .map((dato) => Premio.fromJson(dato))
        .where((premio) => premio.activo)
        .map(_conStockActual)
        .toList()
      ..sort((a, b) => a.costoPuntos.compareTo(b.costoPuntos));
  }

  /// Descuenta una unidad del stock (si el premio tiene límite).
  Future<void> descontarStock(Premio premio) async {
    // TODO: en el backend esto va dentro de la misma operación del canje.
    final stock = premio.stock;
    if (stock == null) return;
    _stockActualizado[premio.id] = stock - 1;
  }

  Premio _conStockActual(Premio premio) {
    final stock = _stockActualizado[premio.id];
    return stock == null ? premio : premio.copyWith(stock: stock);
  }
}
