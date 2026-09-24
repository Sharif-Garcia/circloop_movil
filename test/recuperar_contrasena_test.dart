import 'package:circloop_movil/screens/auth/login_screen.dart';
import 'package:circloop_movil/screens/auth/recuperar_contrasena_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/utils/validators.dart';
import 'package:circloop_movil/widgets/formularios/campo_codigo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pruebas.dart';

const _correoAna = 'anatorres@unicesar.edu.co';

/// Escribe el correo, pulsa "Enviar Código" y espera a que se habilite
/// el resto del formulario.
Future<void> _enviarCodigo(WidgetTester tester, String correo) async {
  await tester.enterText(find.byType(TextFormField).first, correo);
  await tester.tap(find.text(AppStrings.enviarCodigo));
  await esperarA(tester, find.text(AppStrings.codigoEnviado));
}

/// Lee el código que la pantalla muestra en modo de prueba.
String _codigoMostrado() {
  final texto = find.textContaining('Modo de prueba').evaluate().single.widget;
  return RegExp(r'\d{4}').firstMatch((texto as Text).data!)!.group(0)!;
}

Future<void> _escribirCodigo(WidgetTester tester, String codigo) async {
  final casillas = find.descendant(
    of: find.byType(CampoCodigo),
    matching: find.byType(TextField),
  );
  for (var i = 0; i < codigo.length; i++) {
    await tester.enterText(casillas.at(i), codigo[i]);
  }
}

Future<void> _escribirContrasenas(
  WidgetTester tester,
  String nueva,
  String confirmacion,
) async {
  final campos = find.byType(TextFormField);
  await tester.enterText(campos.at(1), nueva);
  await tester.enterText(campos.at(2), confirmacion);
}

void main() {
  configurarPruebas();

  testWidgets('el enlace del login abre la pantalla', (tester) async {
    await abrirPantalla(tester, const LoginScreen());

    await tester.tap(find.text(AppStrings.olvidasteContrasena));
    await tester.pumpAndSettle();

    expect(find.byType(RecuperarContrasenaScreen), findsOneWidget);

    await tester.tap(find.text(AppStrings.volver));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('rechaza correos no institucionales', (tester) async {
    await abrirPantalla(tester, const RecuperarContrasenaScreen());

    await tester.enterText(find.byType(TextFormField).first, 'ana@gmail.com');
    await tester.tap(find.text(AppStrings.enviarCodigo));
    await tester.pump();

    expect(find.textContaining('correo institucional válido'), findsOneWidget);
    expect(find.text(AppStrings.codigoEnviado), findsNothing);
  });

  testWidgets('código incorrecto muestra error', (tester) async {
    await abrirPantalla(tester, const RecuperarContrasenaScreen());
    await _enviarCodigo(tester, _correoAna);

    final correcto = _codigoMostrado();
    final incorrecto = correcto == '0000' ? '1111' : '0000';

    await _escribirCodigo(tester, incorrecto);
    await _escribirContrasenas(tester, 'nueva123', 'nueva123');
    await tester.tap(find.text(AppStrings.restablecerContrasena));
    await esperarA(tester, find.text(AppStrings.codigoInvalido));

    expect(find.text(AppStrings.codigoInvalido), findsOneWidget);
  });

  testWidgets('valida contraseña corta y confirmación distinta', (
    tester,
  ) async {
    await abrirPantalla(tester, const RecuperarContrasenaScreen());
    await _enviarCodigo(tester, _correoAna);

    await _escribirCodigo(tester, _codigoMostrado());
    await _escribirContrasenas(tester, '123', '456');
    await tester.tap(find.text(AppStrings.restablecerContrasena));
    await tester.pump();

    expect(find.text(Validators.contrasenaNueva('123')!), findsOneWidget);
    expect(find.text('Las contraseñas no coinciden.'), findsOneWidget);
  });

  testWidgets('correo no registrado no revela que no existe', (tester) async {
    await abrirPantalla(tester, const RecuperarContrasenaScreen());
    await _enviarCodigo(tester, 'noexiste@unicesar.edu.co');

    // Misma respuesta que un correo registrado, pero sin código
    expect(find.text(AppStrings.mensajeCodigoEnviado), findsOneWidget);
    expect(find.textContaining('Modo de prueba'), findsNothing);
  });

  testWidgets('flujo completo: restablece y entra con la nueva contraseña', (
    tester,
  ) async {
    await abrirPantalla(tester, const LoginScreen());
    await tester.tap(find.text(AppStrings.olvidasteContrasena));
    await tester.pumpAndSettle();

    await _enviarCodigo(tester, _correoAna);
    await _escribirCodigo(tester, _codigoMostrado());
    await _escribirContrasenas(tester, 'nueva123', 'nueva123');
    await tester.tap(find.text(AppStrings.restablecerContrasena));
    await esperarA(tester, find.text(AppStrings.tituloContrasenaActualizada));

    await tester.tap(find.text(AppStrings.irAlLogin));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    // La contraseña anterior ya no sirve
    final error = find.text('Correo o contraseña incorrectos.');
    await iniciarSesion(
      tester,
      correo: _correoAna,
      contrasena: '123456',
      esperado: error,
    );
    expect(error, findsOneWidget);

    // La nueva sí
    final panel = find.text('Panel de Comunidad');
    await iniciarSesion(
      tester,
      correo: _correoAna,
      contrasena: 'nueva123',
      esperado: panel,
    );
    expect(panel, findsOneWidget);
  });
}
