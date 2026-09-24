import 'package:circloop_movil/services/usuario_service.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Deja el estado limpio antes de cada test. Llamar dentro de `main()`.
void configurarPruebas() {
  setUp(() {
    // rootBundle guarda en caché el JSON cargado; esa caché queda atada al
    // test que la creó y colgaría la carga en el siguiente test.
    rootBundle.clear();
    UsuarioService.reiniciarDatosEnMemoria();
  });
}

/// Monta [pantalla] con el tema y Riverpod, en una ventana de celular alta
/// para que todo el contenido quepa sin hacer scroll.
Future<void> abrirPantalla(WidgetTester tester, Widget pantalla) async {
  tester.view.physicalSize = const Size(420, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(theme: AppTheme.lightTheme, home: pantalla),
    ),
  );
}

/// Alterna tiempo real (`runAsync`) y frames hasta que se cumpla [condicion].
/// La carga del JSON es asíncrona real, fuera del reloj falso del test, por
/// eso `pumpAndSettle` solo no basta.
Future<void> esperarHasta(WidgetTester tester, bool Function() condicion) async {
  for (var i = 0; i < 100 && !condicion(); i++) {
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Espera a que aparezca [esperado] y a que terminen las animaciones.
Future<void> esperarA(WidgetTester tester, Finder esperado) async {
  await esperarHasta(tester, () => esperado.evaluate().isNotEmpty);
  await esperarHasta(tester, () => !tester.binding.hasScheduledFrame);
}

/// Llena el login y pulsa "Iniciar sesión" hasta que aparezca [esperado].
Future<void> iniciarSesion(
  WidgetTester tester, {
  required String correo,
  required String contrasena,
  required Finder esperado,
}) async {
  final campos = find.byType(TextFormField);
  await tester.enterText(campos.at(0), correo);
  await tester.enterText(campos.at(1), contrasena);
  await tester.tap(find.text(AppStrings.iniciarSesion));

  await esperarA(tester, esperado);
}
