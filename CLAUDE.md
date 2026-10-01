# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

CIRCLOOP ("Sistema de Devolución y Recompensa") is a Flutter mobile app (Flutter 3.44 / Dart 3.12, Material 3) for a university recycling/reward system at Universidad Popular del Cesar: users have institutional `@unicesar.edu.co` emails, deliver recyclable material and accumulate points they redeem or transfer. All identifiers, UI strings, and comments are in **Spanish** — keep new code consistent (e.g. `iniciarSesion`, `obtenerUsuarios`, `correoInstitucional`); screens are `...Screen` (never `View`), services `...Service`, providers `...Provider`/`...Notifier`.

**`GUIA_CIRCLOOP.md` is the detailed build guide** (written in Spanish, as a prompt for UI generation): full design-token tables, the catalog of every reusable widget with its parameters (§6), data model fields and test users (§7), and the "lo que NO se debe hacer" list (§9). Read the relevant section before building a screen or widget, and keep it updated when adding widgets, tokens or data.

## Commands

```bash
flutter pub get                          # install dependencies
flutter run                              # run the app on a connected device/emulator
flutter analyze                          # lint (flutter_lints); must report "No issues found!"
flutter test                             # run all tests
flutter test test/login_test.dart        # run a single test file
flutter test --plain-name "<test name>"  # run a single test by name

dart run flutter_launcher_icons          # regenerate app icons (config: flutter_launcher_icons.yaml)
dart run flutter_native_splash:create    # regenerate native launch splash (config: flutter_native_splash.yaml)
```

App icons and the native launch splash are generated from the square images in `assets/launcher/` (derived from `assets/images/logo_original.png`; not bundled in the app). Don't hand-edit the generated files under `android/app/src/main/res/`, `ios/Runner/Assets.xcassets/` or `web/icons`/`web/splash` — change the source image and rerun the commands.

The native splash is deliberately just the background color (no logo) so the logo is shown only once, animated, by `SplashScreen`. Android 12+ would otherwise show the app icon, hence `android_12.image: assets/launcher/transparente.png`. `main.dart` calls `FlutterNativeSplash.preserve` (so `flutter_native_splash` is a regular dependency) and `SplashScreen` removes it once the logo is precached, so the animation starts with the image ready.

### Tests

Widget tests (`test/<seccion>_test.dart`) exercise full screen flows against the real JSON data (test users in `assets/data/usuarios.json`, password `123456`; e.g. `anatorres@unicesar.edu.co` is comunidad). Use the helpers in `test/helpers/pruebas.dart`: call `configurarPruebas()` at the top of `main()`, mount screens with `abrirPantalla`, log in with `iniciarSesion`, and use `entrarComoAna`/`irAPestana` for comunidad-panel tests. Find texts via `AppStrings` and assert on `Validators.x(badInput)!` rather than copying messages.

The helpers exist because of two `rootBundle` gotchas: the load is real async, so waiting needs `tester.runAsync` + `pump` loops (`esperarA`/`esperarHasta`; plain `pumpAndSettle` times out), and a cached load from a previous test hangs forever in the next one (hence `rootBundle.clear()` in `setUp`). `configurarPruebas` also resets the in-memory data of every service that has it — **add any new stateful service there**.

## Architecture

Layered, state managed by **Riverpod 3** (`flutter_riverpod`). Data flows **Screen → Provider → Service → JSON**; screens never read JSON or call services directly.

### Navigation

No router; plain `Navigator` with `MaterialPageRoute`. `main.dart` wraps the app in `ProviderScope`; `app.dart` (`MyApp`) uses `AppTheme.lightTheme` and starts at `SplashScreen` (3s) → `OnboardingScreen` → `LoginScreen`, each via `pushReplacement`. `LoginScreen` `ref.listen`s on `authProvider` and, when it becomes `data(usuario)`, navigates to `pantallaInicioPorRol(usuario)` (`screens/auth/sesion.dart`, which also has the shared `cerrarSesion(context, ref)`). Login `push`es `RecuperarContrasenaScreen` and `RegistroScreen`, which `pop` back.

- Rol 1 → `PanelComunidadScreen` (`screens/comunidad/`); other roles get the temporary `InicioRolScreen` (`screens/inicio/`) until they have their own. New role panel = `screens/<rol>/panel_<rol>_screen.dart` + a case in `pantallaInicioPorRol`.
- A panel is a `PanelNavegacion` (`widgets/navegacion/`) with a `BarraSuperior` and `SeccionPanel` tabs kept alive in an `IndexedStack`. Switch tabs from inside with `PanelNavegacion.of(context).irA(i)` (comunidad indices in `PestanaComunidad`) — never `push` a screen that is already a tab. `BarraSuperior(pestanaPerfil: i)` makes the avatar jump to that tab.
- **Tab content has no `Scaffold`/`AppBar`**; a tab's FAB goes in `SeccionPanel(botonFlotante: ...)` so the panel's Scaffold moves it above SnackBars (a nested Scaffold's FAB gets covered). Only screens `push`ed over the panel (historial, `CodigoQrScreen`, `EditarPerfilScreen`, `TransferirPuntosScreen`…) have their own `Scaffold` + `BotonVolver`.
- Shared tabs in `screens/comunes/`: `EnConstruccionScreen` for unbuilt tabs, `NotificacionesScreen`, and `PerfilScreen` — the **single** profile for all roles (with `EditarPerfilScreen` and logout); roles add their part via `PerfilScreen(contenidoRol: ...)` (e.g. `ResumenPerfilComunidad`).

### Layers

- `models/` — immutable classes with a `fromJson` factory (no code generation). Relationships by integer id (`Usuario.rolId`, `Usuario.carreraId`, `Carrera` → `Facultad`).
- `services/` — one per model, loading `assets/data/<entidad>.json` via `rootBundle.loadString` + `jsonDecode`. **There is no backend.** Assets are read-only, so writes are simulated in memory in static fields (`UsuarioService`, `CanjeService`, `PremioService`, `TransferenciaService`, `NotificacionService`), lost on restart and reset via `reiniciarDatosEnMemoria`. These methods are the single place to swap in backend calls (marked `TODO`) — screens and providers shouldn't need changes. Emails are compared trimmed/lowercased. Expected, user-facing failures are thrown as `ServicioException(mensaje)`; providers show `e.mensaje` for those and `AppStrings.errorGeneral` for anything else. Format checks live in `Validators`; business rules are re-checked in services (and must be re-checked by the future backend).
- `services/codigo_verificacion/` — password-reset codes behind the `CodigoVerificacionService` interface. `CodigoVerificacionSimulado` (in use) returns the code so the screen shows it ("Modo de prueba"); `CodigoVerificacionCorreo` is the stub for real email (must go through a backend — never put mail credentials in the app). Swap only in `codigoVerificacionServiceProvider`.
- `providers/` —
  - Read-only data: `FutureProvider` (e.g. `carrerasProvider`, sorted).
  - Actions (submit a form, canjear, transferir): `NotifierProvider.autoDispose` with `AsyncValue<T?>` — `data(null)` idle, `loading`, `data(x)` success, `error(<Spanish message>)`. `authProvider` (`AuthNotifier`, not autoDispose) uses the same shape: `data(null)` = logged out; current user is `ref.watch(authProvider).value`.
  - Lists with actions: `AsyncNotifierProvider` with optimistic `state` updates (`notificacionesProvider`).
  - Multi-step flows: immutable state class + step enum (`EstadoRecuperacion` in `recuperarContrasenaProvider`).
  - Notifiers instantiate services directly; swappable services are exposed as `Provider`s that tests can override. After every `await`, check `ref.mounted` before setting `state`.
- `screens/` — grouped by feature. `ConsumerStatefulWidget`/`ConsumerWidget` that `ref.watch` providers for UI and do side effects (SnackBars, dialogs, navigation) only in `ref.listen` or callbacks, never in `build`. Screens only assemble widgets — no inline styles, colors or texts.
- `utils/` — `AppColors`, `AppSizes`, `AppTheme`, `AppStrings` (all UI text, functions for interpolated ones like `bienvenida(nombre)`), `AppImages`, `Validators` (single source for rules such as password min 8 with letters+numbers), `Formatos`, and key→metadata lookups `AppRol.porId`, `AppMaterial.porClave`, `AppCategoriaPremio`, `AppTipoNotificacion`, `AppIconos.porNombre`. Never hardcode colors/sizes/strings/paths; add a new token here instead.
- `widgets/` — reusable widgets grouped by kind (`comunes/`, `botones/`, `formularios/`, `navegacion/`) plus section-specific folders (`auth/`, `onboarding/`, `comunidad/`). **Check here (or GUIA §6) before writing UI in a screen.** A widget used by only one section goes in `widgets/<seccion>/`.
- Styling is inherited from `AppTheme` (button, input, snackBar, appBar, navigationBar, chip themes and a `textTheme`). Use `Theme.of(context).textTheme.*`, themed buttons and plain `InputDecoration`s rather than inline `TextStyle`/`styleFrom`/borders.
- Static screen content (e.g. onboarding steps in `screens/onboarding/onboarding_pasos.dart`) lives as `const` model lists next to the screen, not in JSON.

### Domain rules

- **Store raw, compute in the app.** JSON holds numbers, ISO dates and keys (`"plastico"`); the UI formats with `Formatos` (`entero` → "1.250", `kilos` → "14,5 kg", `fechaRelativa` → "Hoy, 10:45 AM"). Derived results are never stored: badges (`insignias.json`) hold rules (`criterio` + `meta`) evaluated by `Insignia.lograda(progreso)`; ranking (`rankingComunidadProvider`/`puestoRankingProvider`) is computed from `puntosHistoricos`.
- `ProgresoEco.desde(usuario, entregas, {ahora})` is the **only** place that totals kg/CO₂/deliveries per material/points this month (`progresoUsuarioProvider`). `NivelEco` derives gamification levels from `puntosHistoricos` (XP).
- Points: `puntosTotales` = available, `puntosCanjeados`, `puntosHistoricos` = XP. Transfers (`TransferenciaService.transferir`: recipient must exist, be comunidad, active, not self) move only `puntosTotales`, never XP.
- **Any action that changes the user (points, profile) must end with `authProvider.notifier.actualizarUsuario(usuario)`** so every screen updates (`editarPerfilProvider`, `canjearProvider`, `transferirProvider` do this).
- Canjes: `CanjeService.canjear` validates points and stock, deducts both (`PremioService.descontarStock`), generates a `CJ-XXXXXX` code; `canjearProvider` also invalidates `premiosProvider`. `Premio.stock == null` = unlimited; `activo: false` premios are filtered out in `PremioService`.
- Notifications: services that do something a user should hear about create it themselves via `NotificacionService().crear(...)` (`CanjeService` → own user, `TransferenciaService` → recipient); with a backend the server does it. `notificacionesNoLeidasProvider` drives the bell badge in `BarraSuperior`.
- The user's QR ("Código Eco-Identificador", `CIRC-000001`, scanned by operators) comes from `EcoIdentificadorService`/`ecoIdentificadorProvider`. QR codes are always drawn with the `CodigoQr` widget; confirmations use `mostrarDialogoConfirmacion`.
- Content images come from the DB as URLs and render with `ImagenRemota`; `AppImagen` is only for local brand assets (logo, mascot). No bare `Image.network`/`Image.asset`.
- Roles (`roles.json`): `1 comunidad`, `2 operador`, `3 punto_canje`, `4 administrador` (`AppRol.comunidad`, …). New accounts get `AppRol.comunidad`.
- Auth errors are deliberately generic ("Correo o contraseña incorrectos."; password reset answers the same for unregistered emails) — don't reveal whether an email is registered. Registration is the one exception (it must say the email is taken).

### Flutter / Riverpod API conventions

- `color.withValues(alpha: ...)` (not `withOpacity`), `super.key`, `DropdownButtonFormField(initialValue: ...)` (not `value:`).
- No `StateProvider` (legacy in Riverpod 3): local `setState` for a one-screen filter, a `Notifier` for shared state. No `ChangeNotifier`/`StateNotifier`/Bloc/GetX.
- No `BottomNavigationBar` — use `PanelNavegacion`. Wrap texts inside a `Row` in `Expanded`/`Flexible`.
- Gotcha: a state-dependent `WidgetStateTextStyle` in `chipTheme.labelStyle` is lost inside `ChoiceChip` (label becomes invisible); `chipTheme` holds only the base style and `SelectorChips` sets the selected/unselected label color per chip.
- Imports mix `package:circloop_movil/...` and relative paths; widgets use relative imports.
