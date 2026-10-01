import 'package:circloop_movil/screens/auth/login_screen.dart';
import 'package:circloop_movil/screens/onboarding/onboarding_pasos.dart';
import 'package:circloop_movil/screens/onboarding/onboarding_screen.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pruebas.dart';

void main() {
  configurarPruebas();

  Future<void> abrirEnCelularPequeno(WidgetTester tester) async {
    await abrirPantalla(tester, const OnboardingScreen());
    // Celular pequeño (360 x 640): la ilustración debe caber sin desbordarse
    tester.view.physicalSize = const Size(360, 640);
    await tester.pump();
  }

  Future<void> siguiente(WidgetTester tester) async {
    await tester.tap(find.text(AppStrings.siguiente));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('recorre los pasos con el botón y termina en el login', (
    tester,
  ) async {
    await abrirEnCelularPequeno(tester);

    expect(find.text(pasosOnboarding[0].titulo), findsOneWidget);
    expect(find.text(AppStrings.saltar), findsOneWidget);

    await siguiente(tester);
    expect(find.text(pasosOnboarding[1].titulo), findsOneWidget);

    await siguiente(tester);
    expect(find.text(pasosOnboarding[2].titulo), findsOneWidget);
    expect(find.text(AppStrings.comenzar), findsOneWidget);

    await tester.tap(find.text(AppStrings.comenzar));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('se puede deslizar entre pasos', (tester) async {
    await abrirEnCelularPequeno(tester);

    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(pasosOnboarding[1].titulo), findsOneWidget);
  });
}
