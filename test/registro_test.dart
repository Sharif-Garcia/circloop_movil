import 'package:circloop_movil/models/carrera.dart';
import 'package:circloop_movil/screens/auth/login_screen.dart';
import 'package:circloop_movil/screens/auth/registro_screen.dart';
import 'package:circloop_movil/screens/comunidad/panel_comunidad_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pruebas.dart';

const _carrera = 'Comercio Internacional';

/// Orden de los campos de texto en el formulario.
enum _Campo { nombres, apellidos, correo, contrasena, confirmar }

Future<void> _escribir(WidgetTester tester, _Campo campo, String texto) {
  return tester.enterText(find.byType(TextFormField).at(campo.index), texto);
}

Future<void> _tocar(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _abrirRegistro(WidgetTester tester) async {
  await abrirPantalla(tester, const RegistroScreen());
  // Espera a que carguen las carreras desde el JSON
  await esperarA(tester, find.text(AppStrings.ejemploCarrera));
}

Future<void> _seleccionarCarrera(WidgetTester tester, String nombre) async {
  await _tocar(tester, find.byType(DropdownButtonFormField<Carrera>));
  await tester.pumpAndSettle();
  await tester.tap(find.text(nombre).last);
  await tester.pumpAndSettle();
}

Future<void> _llenarFormulario(
  WidgetTester tester, {
  String correo = 'nuevo@unicesar.edu.co',
}) async {
  await _escribir(tester, _Campo.nombres, 'María José');
  await _escribir(tester, _Campo.apellidos, 'Pérez Gómez');
  await _escribir(tester, _Campo.correo, correo);
  await _escribir(tester, _Campo.contrasena, 'reciclo2024');
  await _escribir(tester, _Campo.confirmar, 'reciclo2024');
  await _seleccionarCarrera(tester, _carrera);
  await _tocar(tester, find.text(AppStrings.aceptoTerminos));
}

void main() {
  configurarPruebas();

  testWidgets('se abre desde el login y vuelve con "Inicia sesión"', (
    tester,
  ) async {
    await abrirPantalla(tester, const LoginScreen());

    await _tocar(tester, find.text(AppStrings.registrate));
    await tester.pumpAndSettle();
    expect(find.byType(RegistroScreen), findsOneWidget);

    await _tocar(tester, find.text(AppStrings.iniciarSesion));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('carga las carreras desde el JSON', (tester) async {
    await _abrirRegistro(tester);

    await _tocar(tester, find.byType(DropdownButtonFormField<Carrera>));
    await tester.pumpAndSettle();

    expect(find.text(_carrera), findsWidgets);
  });

  testWidgets('formulario vacío muestra todos los errores', (tester) async {
    await _abrirRegistro(tester);

    await _tocar(tester, find.text(AppStrings.crearCuenta));

    expect(find.text(Validators.nombre('')!), findsNWidgets(2));
    expect(find.text(Validators.correoInstitucional('')!), findsOneWidget);
    expect(find.text(Validators.contrasenaNueva('')!), findsOneWidget);
    expect(find.text('Confirma tu contraseña.'), findsOneWidget);
    expect(find.text(AppStrings.seleccionaCarrera), findsOneWidget);
    expect(find.text(Validators.aceptarTerminos(false)!), findsOneWidget);
  });

  testWidgets('valida formato de nombre, correo y contraseña', (tester) async {
    await _abrirRegistro(tester);

    await _escribir(tester, _Campo.nombres, 'María123');
    await _escribir(tester, _Campo.correo, 'maria@gmail.com');
    await _escribir(tester, _Campo.contrasena, 'solotexto');
    await _escribir(tester, _Campo.confirmar, 'otracosa');
    await _tocar(tester, find.text(AppStrings.crearCuenta));

    expect(find.text('Solo se permiten letras y espacios.'), findsOneWidget);
    expect(
      find.text(Validators.correoInstitucional('maria@gmail.com')!),
      findsOneWidget,
    );
    expect(
      find.text('La contraseña debe combinar letras y números.'),
      findsOneWidget,
    );
    expect(find.text('Las contraseñas no coinciden.'), findsOneWidget);
  });

  testWidgets('correo ya registrado muestra error', (tester) async {
    await _abrirRegistro(tester);

    await _llenarFormulario(tester, correo: 'AnaTorres@unicesar.edu.co');
    await _tocar(tester, find.text(AppStrings.crearCuenta));
    await esperarA(tester, find.text(AppStrings.correoYaRegistrado));

    expect(find.text(AppStrings.correoYaRegistrado), findsOneWidget);
    expect(find.text(AppStrings.tituloCuentaCreada), findsNothing);
  });

  testWidgets('flujo completo: crea la cuenta y entra con ella', (
    tester,
  ) async {
    await abrirPantalla(tester, const LoginScreen());
    await _tocar(tester, find.text(AppStrings.registrate));
    await esperarA(tester, find.text(AppStrings.ejemploCarrera));

    await _llenarFormulario(tester);
    await _tocar(tester, find.text(AppStrings.crearCuenta));
    await esperarA(tester, find.text(AppStrings.tituloCuentaCreada));

    await tester.tap(find.text(AppStrings.irAlLogin));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    // Cuenta nueva: rol comunidad y sin entregas todavía
    final vacio = find.text(AppStrings.sinEntregas);
    await iniciarSesion(
      tester,
      correo: 'nuevo@unicesar.edu.co',
      contrasena: 'reciclo2024',
      esperado: vacio,
    );
    expect(find.byType(PanelComunidadScreen), findsOneWidget);
    expect(find.text(AppStrings.saludo('María José')), findsOneWidget);
    expect(vacio, findsOneWidget);
  });
}
