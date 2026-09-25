import 'package:circloop_movil/models/nivel_eco.dart';
import 'package:circloop_movil/screens/comunidad/historial_entregas_screen.dart';
import 'package:circloop_movil/screens/comunidad/panel_comunidad_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/utils/formatos.dart';
import 'package:circloop_movil/widgets/comunidad/item_entrega.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pruebas.dart';

void main() {
  configurarPruebas();

  group('Formatos', () {
    test('números con separador de miles', () {
      expect(Formatos.entero(0), '0');
      expect(Formatos.entero(950), '950');
      expect(Formatos.entero(1250), '1.250');
      expect(Formatos.entero(1234567), '1.234.567');
    });

    test('kilos con coma decimal', () {
      expect(Formatos.kilos(14.5), '14,5 kg');
      expect(Formatos.kilos(4.0), '4 kg');
      expect(Formatos.kilos(0.8), '0,8 kg');
    });

    test('fecha relativa', () {
      final ahora = DateTime(2026, 9, 24, 18, 0);
      expect(
        Formatos.fechaRelativa(DateTime(2026, 9, 24, 10, 45), ahora: ahora),
        'Hoy, 10:45 AM',
      );
      expect(
        Formatos.fechaRelativa(DateTime(2026, 9, 23, 16, 20), ahora: ahora),
        'Ayer, 4:20 PM',
      );
      expect(
        Formatos.fechaRelativa(DateTime(2026, 9, 18, 0, 5), ahora: ahora),
        '18 Sep, 12:05 AM',
      );
    });
  });

  group('NivelEco', () {
    test('calcula nivel y progreso según la XP', () {
      final nivel = NivelEco.paraXp(1250);
      expect(nivel.numero, 3);
      expect(nivel.siguiente!.numero, 4);
      expect(nivel.progreso(1250), 0.25);

      expect(NivelEco.paraXp(0).numero, 1);
      expect(NivelEco.paraXp(499).numero, 1);
      expect(NivelEco.paraXp(500).numero, 2);
    });

    test('el último nivel no tiene siguiente y está completo', () {
      final maximo = NivelEco.paraXp(99999);
      expect(maximo.siguiente, isNull);
      expect(maximo.progreso(99999), 1.0);
    });
  });

  testWidgets('el rol comunidad entra a su panel con sus datos', (
    tester,
  ) async {
    await entrarComoAna(tester);

    expect(find.byType(PanelComunidadScreen), findsOneWidget);
    expect(find.text(AppStrings.saludo('Ana')), findsOneWidget);
    // Carrera 7 en carreras.json
    expect(find.text(carreraAna), findsOneWidget);
    // Puntos disponibles en la barra superior
    expect(find.text(AppStrings.puntos('1.100')), findsOneWidget);
    // Nivel según puntos históricos (1250 → nivel 3)
    expect(find.text(AppStrings.nivel(3, 'Eco Warrior')), findsOneWidget);
    // Solo las 3 entregas más recientes
    expect(find.byType(ItemEntrega), findsNWidgets(3));
    // Impacto total de sus 6 entregas: 14,5 kg y 19,7 kg de CO₂
    expect(find.text('14,5 kg'), findsOneWidget);
    expect(find.text('19,7 kg CO₂'), findsOneWidget);
  });

  testWidgets('"Ver Historial" muestra todas las entregas', (tester) async {
    await entrarComoAna(tester);

    await tester.tap(find.text(AppStrings.verHistorial));
    await esperarA(tester, find.byType(HistorialEntregasScreen));

    expect(find.byType(ItemEntrega), findsNWidgets(6));

    await tester.tap(find.text(AppStrings.volver));
    await tester.pumpAndSettle();
    expect(find.byType(PanelComunidadScreen), findsOneWidget);
  });

  testWidgets('los botones de acción cambian de pestaña', (tester) async {
    await entrarComoAna(tester);

    await tester.tap(find.text(AppStrings.canjear));
    await tester.pumpAndSettle();

    final barra = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(barra.selectedIndex, PestanaComunidad.canjes);
  });
}
