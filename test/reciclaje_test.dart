import 'package:circloop_movil/models/entrega.dart';
import 'package:circloop_movil/models/progreso_eco.dart';
import 'package:circloop_movil/models/usuario.dart';
import 'package:circloop_movil/screens/comunidad/codigo_qr_screen.dart';
import 'package:circloop_movil/services/eco_identificador_service.dart';
import 'package:circloop_movil/utils/app_colors.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/widgets/comunidad/item_entrega.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'helpers/pruebas.dart';

Usuario _usuario({int id = 1}) {
  return Usuario(
    id: id,
    nombres: 'Prueba',
    apellidos: 'Prueba',
    correoInstitucional: 'prueba@unicesar.edu.co',
    contrasena: '123456',
    rolId: 1,
    activo: true,
    puntosTotales: 0,
    puntosCanjeados: 0,
    puntosHistoricos: 0,
  );
}

Entrega _entrega(DateTime fecha, int puntos) {
  return Entrega(
    id: 1,
    usuarioId: 1,
    material: 'papel',
    pesoKg: 1,
    co2EvitadoKg: 1,
    puntos: puntos,
    fecha: fecha,
  );
}

Future<void> _abrirReciclaje(WidgetTester tester) async {
  await entrarComoAna(tester);
  await irAPestana(tester, AppStrings.navReciclaje);
}

Future<void> _filtrar(WidgetTester tester, String material) async {
  final chip = find.widgetWithText(ChoiceChip, material);
  await tester.ensureVisible(chip);
  await tester.tap(chip);
  await tester.pumpAndSettle();
}

void main() {
  configurarPruebas();

  test('los puntos del mes solo cuentan entregas del mes en curso', () {
    final progreso = ProgresoEco.desde(_usuario(), [
      _entrega(DateTime(2026, 9, 24), 50),
      _entrega(DateTime(2026, 9, 1), 20),
      _entrega(DateTime(2026, 8, 31), 100),
      _entrega(DateTime(2025, 9, 10), 100),
    ], ahora: DateTime(2026, 9, 30));

    expect(progreso.puntosMes, 70);
    expect(progreso.cantidadEntregas, 4);
  });

  test(
    'el código Eco-Identificador es único por usuario y reversible',
    () async {
      final servicio = EcoIdentificadorService();

      final codigo = await servicio.obtenerCodigo(_usuario(id: 42));
      expect(codigo, 'CIRC-000042');
      expect(EcoIdentificadorService.idDesdeCodigo(codigo), 42);

      expect(
        await servicio.obtenerCodigo(_usuario(id: 1)),
        isNot(equals(codigo)),
      );
      expect(EcoIdentificadorService.idDesdeCodigo('OTRO-000042'), isNull);
      expect(EcoIdentificadorService.idDesdeCodigo('CIRC-abc'), isNull);
    },
  );

  testWidgets('muestra el resumen y todas las entregas', (tester) async {
    await _abrirReciclaje(tester);

    expect(find.text(AppStrings.entregas), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('14,5 kg'), findsOneWidget);
    expect(find.byType(ItemEntrega), findsNWidgets(6));
  });

  testWidgets('los chips sin seleccionar tienen texto visible', (tester) async {
    await _abrirReciclaje(tester);

    Color? colorTexto(String texto) =>
        DefaultTextStyle.of(tester.element(find.text(texto).first)).style.color;

    // "Todos" está seleccionado (texto blanco sobre verde); el resto no
    expect(colorTexto(AppStrings.todos), AppColors.white);
    expect(colorTexto('Plástico'), AppColors.textPrimary);
    expect(colorTexto('Vidrio'), AppColors.textPrimary);
  });

  testWidgets('filtra las entregas por material', (tester) async {
    await _abrirReciclaje(tester);

    await _filtrar(tester, 'Vidrio');
    expect(find.byType(ItemEntrega), findsOneWidget);

    await _filtrar(tester, 'Plástico');
    expect(find.byType(ItemEntrega), findsNWidgets(2));

    await _filtrar(tester, 'Orgánico');
    expect(find.byType(ItemEntrega), findsNothing);
    expect(find.text(AppStrings.sinEntregasMaterial), findsOneWidget);

    await _filtrar(tester, AppStrings.todos);
    expect(find.byType(ItemEntrega), findsNWidgets(6));
  });

  testWidgets('"Mi Código QR" muestra un QR real con el código del usuario', (
    tester,
  ) async {
    await _abrirReciclaje(tester);

    await tester.tap(find.text(AppStrings.miCodigoQr));
    await esperarA(tester, find.byType(QrImageView));

    expect(find.byType(CodigoQrScreen), findsOneWidget);
    expect(find.text('CIRC-000001'), findsOneWidget);
    expect(find.text('Ana Torres Martínez'), findsOneWidget);
    expect(find.text(AppStrings.puntos('1.100')), findsOneWidget);
    expect(find.text('Eco Warrior'), findsOneWidget);

    await tester.tap(find.text(AppStrings.volver));
    await tester.pumpAndSettle();
    expect(find.byType(CodigoQrScreen), findsNothing);
  });

  testWidgets('el botón "Reciclar" del inicio abre la pestaña', (tester) async {
    await entrarComoAna(tester);

    await tester.tap(find.text(AppStrings.reciclar));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.miCodigoQr), findsOneWidget);
  });
}
