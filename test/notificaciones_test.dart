import 'package:circloop_movil/screens/auth/login_screen.dart';
import 'package:circloop_movil/screens/comunes/notificaciones_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/widgets/comunidad/tarjeta_premio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pruebas.dart';

/// Globo de la campana con [cantidad] sin leer.
Finder _globo(int cantidad) =>
    find.descendant(of: find.byType(Badge), matching: find.text('$cantidad'));

Finder get _sinLeer => find.byKey(const ValueKey('sin-leer'));

Future<void> _tocar(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _abrirNotificaciones(WidgetTester tester) async {
  await _tocar(tester, find.byTooltip(AppStrings.notificaciones));
  await esperarA(tester, find.byType(NotificacionesScreen));
}

Future<void> _cerrarSesion(WidgetTester tester) async {
  await irAPestana(tester, AppStrings.navPerfil);
  await _tocar(tester, find.text(AppStrings.cerrarSesion));
  expect(find.byType(LoginScreen), findsOneWidget);
}

void main() {
  configurarPruebas();

  testWidgets('la campana muestra cuántas hay sin leer', (tester) async {
    await entrarComoAna(tester);
    await esperarA(tester, _globo(2));

    expect(_globo(2), findsOneWidget);
  });

  testWidgets('lista las notificaciones, más recientes primero', (
    tester,
  ) async {
    await entrarComoAna(tester);
    await _abrirNotificaciones(tester);

    expect(find.text(AppStrings.noLeidas(2)), findsOneWidget);
    expect(_sinLeer, findsNWidgets(2));

    final entrega = tester.getTopLeft(find.text('Entrega registrada'));
    final bienvenida = tester.getTopLeft(find.text('¡Bienvenida a CIRCLOOP!'));
    expect(entrega.dy, lessThan(bienvenida.dy));
  });

  testWidgets('tocar una la marca como leída y baja el contador', (
    tester,
  ) async {
    await entrarComoAna(tester);
    await _abrirNotificaciones(tester);

    await _tocar(tester, find.text('Entrega registrada'));

    expect(find.text(AppStrings.noLeidas(1)), findsOneWidget);
    expect(_sinLeer, findsOneWidget);

    await _tocar(tester, find.text(AppStrings.volver));
    expect(_globo(1), findsOneWidget);
  });

  testWidgets('"Marcar todas como leídas" deja la campana sin globo', (
    tester,
  ) async {
    await entrarComoAna(tester);
    await _abrirNotificaciones(tester);

    await _tocar(tester, find.text(AppStrings.marcarTodasLeidas));

    expect(_sinLeer, findsNothing);
    expect(find.text(AppStrings.noLeidas(0)), findsOneWidget);
    expect(find.text(AppStrings.marcarTodasLeidas), findsNothing);

    await _tocar(tester, find.text(AppStrings.volver));
    final globo = tester.widget<Badge>(find.byType(Badge));
    expect(globo.isLabelVisible, isFalse);
  });

  testWidgets('canjear un premio genera una notificación con el código', (
    tester,
  ) async {
    await entrarComoAna(tester);
    await irAPestana(tester, AppStrings.navCanjes);
    await esperarA(tester, find.text('Café Americano Gratis'));

    final boton = find.descendant(
      of: find.ancestor(
        of: find.text('Café Americano Gratis'),
        matching: find.byType(TarjetaPremio),
      ),
      matching: find.byType(FilledButton),
    );
    await _tocar(tester, boton);
    await _tocar(tester, find.text(AppStrings.confirmar));
    await esperarA(tester, find.text(AppStrings.canjeExitosoTitulo));
    await _tocar(tester, find.text(AppStrings.entendido));
    await esperarA(tester, _globo(3));

    await _abrirNotificaciones(tester);
    expect(find.text(AppStrings.notifCanjeTitulo), findsOneWidget);
    expect(
      find.textContaining(RegExp(r'código CJ-[A-Z2-9]{6}')),
      findsOneWidget,
    );
  });

  testWidgets('quien recibe una transferencia recibe una notificación', (
    tester,
  ) async {
    await entrarComoAna(tester);
    await irAPestana(tester, AppStrings.navCanjes);
    await _tocar(tester, find.text(AppStrings.transferirPuntos));

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'julianrios@unicesar.edu.co');
    await tester.enterText(campos.at(1), '100');
    await tester.enterText(campos.at(2), 'Para tu proyecto');
    await _tocar(
      tester,
      find.widgetWithText(FilledButton, AppStrings.transferirPuntos),
    );
    await _tocar(tester, find.text(AppStrings.confirmar));
    await esperarA(tester, find.text(AppStrings.transferenciaExitosaTitulo));
    await _tocar(tester, find.text(AppStrings.entendido));
    await _cerrarSesion(tester);

    // Julián no tenía notificaciones; ahora tiene 1 sin leer
    await iniciarSesion(
      tester,
      correo: 'julianrios@unicesar.edu.co',
      contrasena: '123456',
      esperado: _globo(1),
    );
    await _abrirNotificaciones(tester);

    expect(find.text(AppStrings.notifTransferenciaTitulo), findsOneWidget);
    expect(
      find.textContaining(
        AppStrings.notifTransferenciaMensaje(
          'Ana Torres Martínez',
          '100',
          'Para tu proyecto',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('sin notificaciones muestra el mensaje vacío', (tester) async {
    await abrirPantalla(tester, const LoginScreen());
    await iniciarSesion(
      tester,
      correo: 'julianrios@unicesar.edu.co',
      contrasena: '123456',
      esperado: find.byTooltip(AppStrings.notificaciones),
    );
    await _abrirNotificaciones(tester);

    expect(find.text(AppStrings.sinNotificaciones), findsOneWidget);
  });
}
