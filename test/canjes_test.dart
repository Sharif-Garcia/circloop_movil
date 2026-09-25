import 'package:circloop_movil/screens/comunidad/mis_canjes_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:circloop_movil/widgets/comunes/codigo_qr.dart';
import 'package:circloop_movil/widgets/comunidad/tarjeta_premio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pruebas.dart';

const _cafe = 'Café Americano Gratis';

Future<void> _abrirCanjes(WidgetTester tester) async {
  await entrarComoAna(tester);
  await irAPestana(tester, AppStrings.navCanjes);
  await esperarA(tester, find.byType(TarjetaPremio));
}

/// Botón de la tarjeta del premio con [titulo].
Finder _botonDe(String titulo) {
  return find.descendant(
    of: find.ancestor(
      of: find.text(titulo),
      matching: find.byType(TarjetaPremio),
    ),
    matching: find.byType(FilledButton),
  );
}

Future<void> _tocar(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  configurarPruebas();

  testWidgets('muestra puntos, elegibles y el catálogo', (tester) async {
    await _abrirCanjes(tester);

    // Barra superior + tarjeta de puntos
    expect(find.text(AppStrings.puntos('1.100')), findsNWidgets(2));
    // Alcanzan 150, 300 y 850; la de 400 está agotada y 1.500 no alcanza.
    // El premio inactivo (retirado del catálogo) no aparece.
    expect(find.text(AppStrings.elegibles(3)), findsOneWidget);
    expect(find.byType(TarjetaPremio), findsNWidgets(5));
  });

  testWidgets('filtra por categoría y avisa cuántos puntos faltan', (
    tester,
  ) async {
    await _abrirCanjes(tester);

    await _tocar(tester, find.widgetWithText(ChoiceChip, 'Comida'));
    expect(find.byType(TarjetaPremio), findsNWidgets(2));

    await _tocar(tester, find.widgetWithText(ChoiceChip, 'Experiencias'));
    expect(find.byType(TarjetaPremio), findsOneWidget);
    expect(find.text(AppStrings.faltanPuntos('400')), findsOneWidget);

    final boton = tester.widget<FilledButton>(
      _botonDe('Taller de Huerta Urbana'),
    );
    expect(boton.onPressed, isNull);
  });

  testWidgets('los premios agotados no se pueden canjear', (tester) async {
    await _abrirCanjes(tester);

    const libreta = 'Libreta Ecológica CircLoop';
    final boton = tester.widget<FilledButton>(_botonDe(libreta));
    expect(boton.onPressed, isNull);
    // Etiqueta sobre la imagen + texto del botón
    expect(find.text(AppStrings.agotado), findsNWidgets(2));
  });

  testWidgets('canjear descuenta el stock del premio', (tester) async {
    await _abrirCanjes(tester);

    const botella = 'Eco Botella de Aluminio';
    expect(find.text(AppStrings.quedan(3)), findsOneWidget);

    await _tocar(tester, _botonDe(botella));
    await _tocar(tester, find.text(AppStrings.confirmar));
    await esperarA(tester, find.text(AppStrings.canjeExitosoTitulo));
    await _tocar(tester, find.text(AppStrings.entendido));
    await esperarA(tester, find.text(AppStrings.quedan(2)));

    expect(find.text(AppStrings.quedan(2)), findsOneWidget);
  });

  testWidgets('cancelar la confirmación no descuenta puntos', (tester) async {
    await _abrirCanjes(tester);

    await _tocar(tester, _botonDe(_cafe));
    expect(find.text(AppStrings.confirmarCanjeTitulo(_cafe)), findsOneWidget);

    await _tocar(tester, find.text(AppStrings.cancelar));
    expect(find.text(AppStrings.puntos('1.100')), findsNWidgets(2));
  });

  testWidgets('canjear descuenta puntos y genera un código por reclamar', (
    tester,
  ) async {
    await _abrirCanjes(tester);

    await _tocar(tester, _botonDe(_cafe));
    await _tocar(tester, find.text(AppStrings.confirmar));
    await esperarA(tester, find.text(AppStrings.canjeExitosoTitulo));

    await _tocar(tester, find.text(AppStrings.entendido));

    // 1.100 - 150 en la barra superior y en la tarjeta de puntos
    expect(find.text(AppStrings.puntos('950')), findsNWidgets(2));
    // Con 950 aún alcanzan los mismos 3 (el más caro cuesta 850)
    expect(find.text(AppStrings.elegibles(3)), findsOneWidget);

    // Mis Canjes: el nuevo (por reclamar) y el que ya tenía (reclamado)
    await _tocar(tester, find.text(AppStrings.misCanjes));
    await esperarA(tester, find.text(AppStrings.porReclamar));

    expect(find.byType(MisCanjesScreen), findsOneWidget);
    expect(find.text(AppStrings.porReclamar), findsOneWidget);
    expect(find.text(AppStrings.reclamado), findsOneWidget);

    // Al tocar el pendiente se ve su QR y su código
    await _tocar(tester, find.text(AppStrings.porReclamar));
    expect(find.byType(CodigoQr), findsOneWidget);
    expect(find.textContaining(RegExp(r'^CJ-[A-Z2-9]{6}$')), findsOneWidget);
  });

  testWidgets('los puntos canjeados se reflejan en el perfil', (tester) async {
    await _abrirCanjes(tester);

    await _tocar(tester, _botonDe(_cafe));
    await _tocar(tester, find.text(AppStrings.confirmar));
    await esperarA(tester, find.text(AppStrings.canjeExitosoTitulo));
    await _tocar(tester, find.text(AppStrings.entendido));

    await irAPestana(tester, AppStrings.navPerfil);
    expect(find.text('950'), findsOneWidget);
  });
}
