import 'package:circloop_movil/models/insignia.dart';
import 'package:circloop_movil/models/nivel_eco.dart';
import 'package:circloop_movil/models/progreso_eco.dart';
import 'package:circloop_movil/screens/auth/login_screen.dart';
import 'package:circloop_movil/screens/comunes/editar_perfil_screen.dart';
import 'package:circloop_movil/screens/comunidad/panel_comunidad_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/utils/validators.dart';
import 'package:circloop_movil/widgets/comunes/avatar_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pruebas.dart';

/// Progreso de prueba para evaluar insignias sin cargar datos.
ProgresoEco _progreso({
  int entregas = 0,
  double kg = 0,
  double co2 = 0,
  Map<String, int> materiales = const {},
  int xp = 0,
}) {
  return ProgresoEco(
    cantidadEntregas: entregas,
    pesoKg: kg,
    co2EvitadoKg: co2,
    entregasPorMaterial: materiales,
    nivel: NivelEco.paraXp(xp),
  );
}

Insignia _insignia(String criterio, double meta, {String? material}) {
  return Insignia(
    id: 1,
    nombre: 'Prueba',
    descripcion: 'Prueba',
    icono: 'star',
    criterio: criterio,
    meta: meta,
    material: material,
  );
}

Future<void> _abrirPerfil(WidgetTester tester) async {
  await entrarComoAna(tester);
  await irAPestana(tester, AppStrings.navPerfil);
  await esperarA(tester, find.text(AppStrings.insigniasLogradas(4, 6)));
}

void main() {
  configurarPruebas();

  group('Insignia.lograda', () {
    test('se gana al alcanzar la meta de cada criterio', () {
      expect(_insignia('entregas', 1).lograda(_progreso(entregas: 1)), isTrue);
      expect(_insignia('entregas', 1).lograda(_progreso()), isFalse);
      expect(_insignia('kg', 10).lograda(_progreso(kg: 9.9)), isFalse);
      expect(_insignia('kg', 10).lograda(_progreso(kg: 10)), isTrue);
      expect(_insignia('co2', 15).lograda(_progreso(co2: 20)), isTrue);
      expect(_insignia('nivel', 4).lograda(_progreso(xp: 1999)), isFalse);
      expect(_insignia('nivel', 4).lograda(_progreso(xp: 2000)), isTrue);
    });

    test('el criterio de material cuenta solo ese material', () {
      final vidrio = _insignia('material', 1, material: 'vidrio');
      expect(vidrio.lograda(_progreso(materiales: {'papel': 3})), isFalse);
      expect(vidrio.lograda(_progreso(materiales: {'vidrio': 1})), isTrue);
    });

    test('un criterio desconocido nunca se gana', () {
      expect(_insignia('otro', 0.5).lograda(_progreso(kg: 100)), isFalse);
    });
  });

  testWidgets('el perfil de comunidad muestra sus datos reales', (
    tester,
  ) async {
    await _abrirPerfil(tester);

    expect(find.text('Ana Torres Martínez'), findsOneWidget);
    expect(find.text(correoAna), findsOneWidget);
    expect(find.text(carreraAna), findsOneWidget);
    expect(find.text(AppStrings.nivel(3, 'Eco Warrior')), findsOneWidget);

    // Puntos disponibles, kg de sus 6 entregas y puesto en el ranking
    expect(find.text('1.100'), findsOneWidget);
    expect(find.text('14,5 kg'), findsOneWidget);
    expect(find.text(AppStrings.puesto(1)), findsOneWidget);

    // 4 de 6 según sus entregas: le faltan nivel 4 y 50 kg
    expect(find.text(AppStrings.insigniasLogradas(4, 6)), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
  });

  testWidgets('tocar el avatar de la barra superior abre el perfil', (
    tester,
  ) async {
    await entrarComoAna(tester);

    await tester.tap(find.byType(AvatarUsuario).first);
    await tester.pumpAndSettle();

    final barra = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(barra.selectedIndex, PestanaComunidad.perfil);
  });

  testWidgets('editar perfil valida y actualiza el nombre en toda la app', (
    tester,
  ) async {
    await _abrirPerfil(tester);

    await tester.tap(find.text(AppStrings.editarPerfil));
    await esperarA(tester, find.byType(EditarPerfilScreen));

    // Los campos vienen con los datos actuales
    final campos = find.byType(TextFormField);
    expect(find.text('Ana'), findsOneWidget);

    // Validación
    await tester.enterText(campos.at(0), '');
    await tester.tap(find.text(AppStrings.guardarCambios));
    await tester.pump();
    expect(find.text(Validators.nombre('')!), findsOneWidget);

    // Guardar
    await tester.enterText(campos.at(0), 'Ana María');
    await tester.tap(find.text(AppStrings.guardarCambios));
    await esperarA(tester, find.text('Ana María Torres Martínez'));

    expect(find.byType(EditarPerfilScreen), findsNothing);
    expect(find.text(AppStrings.perfilActualizado), findsOneWidget);

    // El saludo del inicio también cambia
    await irAPestana(tester, AppStrings.navInicio);
    expect(find.text(AppStrings.saludo('Ana María')), findsOneWidget);
  });

  testWidgets('cerrar sesión desde el perfil vuelve al login', (tester) async {
    await _abrirPerfil(tester);

    await tester.tap(find.text(AppStrings.cerrarSesion));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(PanelComunidadScreen), findsNothing);
  });
}
