import 'package:circloop_movil/screens/auth/login_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pruebas.dart';

void main() {
  configurarPruebas();

  testWidgets('muestra el formulario de login', (tester) async {
    await abrirPantalla(tester, const LoginScreen());

    expect(find.text(AppStrings.tituloLogin), findsOneWidget);
    expect(find.text(AppStrings.correoInstitucional), findsOneWidget);
    expect(find.text(AppStrings.contrasena), findsOneWidget);
    expect(find.text(AppStrings.olvidasteContrasena), findsOneWidget);
  });

  testWidgets('valida campos vacíos', (tester) async {
    await abrirPantalla(tester, const LoginScreen());

    await tester.tap(find.text(AppStrings.iniciarSesion));
    await tester.pump();

    expect(find.text('Ingresa tus credenciales.'), findsNWidgets(2));
  });

  testWidgets('credenciales incorrectas muestran error', (tester) async {
    await abrirPantalla(tester, const LoginScreen());

    final error = find.text('Correo o contraseña incorrectos.');
    await iniciarSesion(
      tester,
      correo: 'anatorres@unicesar.edu.co',
      contrasena: 'malaclave',
      esperado: error,
    );

    expect(error, findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('login correcto lleva al panel según el rol', (tester) async {
    await abrirPantalla(tester, const LoginScreen());

    final panel = find.text('Panel de Operador');
    await iniciarSesion(
      tester,
      correo: 'carlosperez@unicesar.edu.co',
      contrasena: '123456',
      esperado: panel,
    );

    expect(panel, findsOneWidget);
    expect(find.text(AppStrings.saludo('Carlos')), findsOneWidget);

    // Cerrar sesión vuelve al login
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
