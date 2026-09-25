import 'package:circloop_movil/screens/auth/login_screen.dart';
import 'package:circloop_movil/screens/comunidad/transferir_puntos_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pruebas.dart';

const _correoJulian = 'julianrios@unicesar.edu.co';

/// Orden de los campos del formulario.
enum _Campo { correo, cantidad, mensaje }

Future<void> _escribir(WidgetTester tester, _Campo campo, String texto) {
  return tester.enterText(find.byType(TextFormField).at(campo.index), texto);
}

Future<void> _tocar(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _abrirTransferir(WidgetTester tester) async {
  await entrarComoAna(tester);
  await irAPestana(tester, AppStrings.navCanjes);
  await _tocar(tester, find.text(AppStrings.transferirPuntos));
  expect(find.byType(TransferirPuntosScreen), findsOneWidget);
}

/// Llena el formulario, pulsa enviar y confirma.
Future<void> _enviar(
  WidgetTester tester, {
  required String correo,
  required String cantidad,
}) async {
  await _escribir(tester, _Campo.correo, correo);
  await _escribir(tester, _Campo.cantidad, cantidad);
  await _tocar(
    tester,
    find.widgetWithText(FilledButton, AppStrings.transferirPuntos),
  );
  await _tocar(tester, find.text(AppStrings.confirmar));
}

void main() {
  configurarPruebas();

  group('Validators.cantidadPuntos', () {
    final validar = Validators.cantidadPuntos(1100);

    test('acepta enteros entre 1 y lo disponible', () {
      expect(validar('1'), isNull);
      expect(validar('1100'), isNull);
    });

    test('rechaza vacío, cero, texto y más de lo disponible', () {
      expect(validar(''), 'Ingresa una cantidad de puntos.');
      expect(validar('0'), 'Ingresa un número entero mayor a 0.');
      expect(validar('abc'), 'Ingresa un número entero mayor a 0.');
      expect(validar('1101'), 'Solo tienes 1.100 puntos disponibles.');
    });
  });

  testWidgets('valida el formulario antes de enviar', (tester) async {
    await _abrirTransferir(tester);

    await _escribir(tester, _Campo.correo, 'julian@gmail.com');
    await _escribir(tester, _Campo.cantidad, '5000');
    await _escribir(tester, _Campo.mensaje, 'x' * 121);
    await _tocar(
      tester,
      find.widgetWithText(FilledButton, AppStrings.transferirPuntos),
    );

    expect(
      find.text(Validators.correoInstitucional('julian@gmail.com')!),
      findsOneWidget,
    );
    expect(find.text(Validators.cantidadPuntos(1100)('5000')!), findsOneWidget);
    expect(find.text(Validators.textoMaximo(120)('x' * 121)!), findsOneWidget);
    // No se pidió confirmación
    expect(find.text(AppStrings.confirmar), findsNothing);
  });

  testWidgets('la cantidad solo acepta números', (tester) async {
    await _abrirTransferir(tester);

    await _escribir(tester, _Campo.cantidad, '12abc');

    final campo = tester.widget<EditableText>(
      find.descendant(
        of: find.byType(TextFormField).at(_Campo.cantidad.index),
        matching: find.byType(EditableText),
      ),
    );
    expect(campo.controller.text, '12');
  });

  testWidgets('rechaza destinatarios no válidos', (tester) async {
    await _abrirTransferir(tester);

    await _enviar(tester, correo: 'nadie@unicesar.edu.co', cantidad: '10');
    await esperarA(tester, find.text(AppStrings.destinatarioNoExiste));
    expect(find.text(AppStrings.destinatarioNoExiste), findsOneWidget);

    await _enviar(tester, correo: correoAna, cantidad: '10');
    await esperarA(tester, find.text(AppStrings.transferenciaASiMismo));
    expect(find.text(AppStrings.transferenciaASiMismo), findsOneWidget);

    // Carlos es operador, no miembro de la comunidad
    await _enviar(
      tester,
      correo: 'carlosperez@unicesar.edu.co',
      cantidad: '10',
    );
    await esperarA(tester, find.text(AppStrings.destinatarioNoValido));
    expect(find.text(AppStrings.destinatarioNoValido), findsOneWidget);

    // Nada de eso descontó puntos
    expect(find.text(AppStrings.puntos('1.100')), findsOneWidget);
  });

  testWidgets('transfiere: descuenta a Ana y suma a Julián', (tester) async {
    await _abrirTransferir(tester);

    await _enviar(tester, correo: _correoJulian, cantidad: '100');
    await esperarA(tester, find.text(AppStrings.transferenciaExitosaTitulo));
    await _tocar(tester, find.text(AppStrings.entendido));

    // Vuelve a Canjes con 1.000 en la barra superior y en la tarjeta
    expect(find.byType(TransferirPuntosScreen), findsNothing);
    expect(find.text(AppStrings.puntos('1.000')), findsNWidgets(2));

    // Julián recibe los puntos (480 + 100) al iniciar sesión
    await irAPestana(tester, AppStrings.navPerfil);
    await _tocar(tester, find.text(AppStrings.cerrarSesion));
    expect(find.byType(LoginScreen), findsOneWidget);

    await iniciarSesion(
      tester,
      correo: _correoJulian,
      contrasena: '123456',
      esperado: find.text(AppStrings.puntos('580')),
    );
    expect(find.text(AppStrings.puntos('580')), findsOneWidget);
  });
}
