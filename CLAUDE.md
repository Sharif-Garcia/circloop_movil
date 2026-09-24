# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

CIRCLOOP ("Sistema de Devolución y Recompensa") is a Flutter mobile app for a university recycling/reward system (users have institutional `@unicesar.edu.co` emails and accumulate points). All identifiers, UI strings, and comments are in **Spanish** — keep new code consistent (e.g. `iniciarSesion`, `obtenerUsuarios`, `correoInstitucional`).

## Commands

```bash
flutter pub get                          # install dependencies
flutter run                              # run the app on a connected device/emulator
flutter analyze                          # lint (flutter_lints via analysis_options.yaml)
flutter test                             # run all tests
flutter test test/login_test.dart        # run a single test file
flutter test --plain-name "<test name>"  # run a single test by name

dart run flutter_launcher_icons          # regenerate app icons (config: flutter_launcher_icons.yaml)
dart run flutter_native_splash:create    # regenerate native launch splash (config: flutter_native_splash.yaml)
```

App icons and the native launch splash for Android/iOS/web are generated from the square images in `assets/launcher/` (derived from `assets/images/logo_original.png`; not bundled in the app). Don't hand-edit the generated files under `android/app/src/main/res/`, `ios/Runner/Assets.xcassets/` or `web/icons`/`web/splash` — change the source image and rerun the commands.

Widget tests (`test/*_test.dart`) exercise full screen flows against the real JSON data (test users in `assets/data/usuarios.json`, password `123456`). Use the shared helpers in `test/helpers/pruebas.dart`: call `configurarPruebas()` at the top of `main()` and mount screens with `abrirPantalla`. They exist because of two gotchas with `rootBundle`: the load is real async, so waiting needs `tester.runAsync` + `pump` loops (`esperarA`/`esperarHasta`; plain `pumpAndSettle` times out), and a cached load from a previous test hangs forever in the next one (hence `rootBundle.clear()` in `setUp`).

## Architecture

Layered structure under `lib/`, with state managed by **Riverpod 3** (`flutter_riverpod`):

- `main.dart` wraps the app in `ProviderScope`; `app.dart` (`MyApp`) builds the `MaterialApp` with `AppTheme.lightTheme` and `SplashScreen` as home. Flow: `SplashScreen` (3s) → `OnboardingScreen` → `LoginScreen` → `InicioRolScreen` (temporary per-role panel; logout returns to login), each via `Navigator.pushReplacement`. `LoginScreen` navigates from a `ref.listen` on `authProvider` when it becomes `data(usuario)`; it also `push`es `RecuperarContrasenaScreen` and `RegistroScreen`, which `pop` back to it when done. There is no router yet.
- `models/` — plain immutable classes with a `fromJson` factory (no code generation). Relationships are by integer id (`Usuario.rolId`, `Usuario.carreraId`, `Carrera` → `Facultad`).
- `services/` — one service per model that loads data from the bundled JSON files in `assets/data/` via `rootBundle.loadString` + `jsonDecode`. **There is no backend**; these JSON files are the mock data source (users, roles, careers, faculties). New data files must live in `assets/data/` (already registered in `pubspec.yaml`). Since assets are read-only, writes are simulated in memory in static fields of `UsuarioService` (`registrar` appends to a list merged into `obtenerUsuarios`; `actualizarContrasena` keeps a map checked by `iniciarSesion`; lost on restart; reset in tests via `reiniciarDatosEnMemoria`). These methods are the single place to swap in backend calls (marked `TODO`) — screens and providers shouldn't need changes. Emails are compared trimmed/lowercased. Expected, user-facing failures are thrown as `ServicioException(mensaje)` (`services/servicio_exception.dart`); providers show `e.mensaje` for those and `AppStrings.errorGeneral` for anything else.
- `services/codigo_verificacion/` — password-reset codes behind the `CodigoVerificacionService` interface. `CodigoVerificacionSimulado` (in use) generates the code in memory and returns it so the screen shows it ("Modo de prueba"); `CodigoVerificacionCorreo` is the stub for real email delivery (must go through a backend — never put mail credentials in the app). Swap implementations only in `codigoVerificacionServiceProvider` (`providers/recuperar_contrasena_provider.dart`).
- `providers/` — Riverpod `Notifier`s exposing `AsyncValue` state. `authProvider` (`AuthNotifier`) holds `AsyncValue<Usuario?>`: `data(null)` = logged out, `loading` during login, `error(<Spanish message>)` for bad credentials/inactive user. `registroProvider` (autoDispose) follows the same `AsyncValue<Usuario?>` pattern. `carrerasProvider` is a cached `FutureProvider` (sorted careers for dropdowns). `recuperarContrasenaProvider` (autoDispose) holds an immutable `EstadoRecuperacion` (step enum, `cargando`, one-shot `error`) that the screen reacts to via `ref.listen`. Notifiers instantiate `UsuarioService` directly; swappable services are exposed as `Provider`s (e.g. `codigoVerificacionServiceProvider`), which tests can override. After an `await` in a notifier, check `ref.mounted` before setting `state`.
- `screens/` — grouped by feature (`screens/auth/`). Screens are `ConsumerStatefulWidget`s that `ref.watch` providers for UI state and `ref.listen` to surface errors via `SnackBar`.
- `utils/` — design tokens and helpers: `AppColors` (palette), `AppSizes` (spacing/icon sizes like `AppSizes.md`, `AppSizes.iconXl`), `AppTheme` (Material 3 `ColorScheme` built from `AppColors`), `Validators` (static form validators returning Spanish error strings; single source for rules like `longitudMinimaContrasena` = 8 with letters+numbers, shared by registration and password reset — tests should assert on `Validators.x(badInput)!` rather than copying messages), `AppImages` (asset paths under `assets/images/`), `AppStrings` (all UI texts, incl. functions for interpolated ones like `bienvenida(nombre)`), `AppRol` (per-role name/panel title/icon/color, looked up with `AppRol.porId(usuario.rolId)`). Use these instead of hardcoded colors/spacing/paths/texts.
- `widgets/` — reusable widgets, grouped by kind (check here before writing UI in a screen):
  - `comunes/`: `AppImagen` (asset image with icon fallback if the file is missing), `AppLogo`, `AppMarca` (small logo + name), `AppTarjeta` (white bordered card), `EncabezadoSeccion` (left-aligned title + subtitle), `IndicadorPaginas` (step dots), `AppMensaje.exito/error/aviso/info` (colored SnackBars), `mostrarDialogoExito`.
  - `botones/`: `BotonPrimario` (full-width, loading state), `BotonVolver`, `EnlaceTexto` ("¿Ya tienes cuenta? **Inicia sesión**"; uses `Wrap` so it never overflows).
  - `formularios/`: `CampoTexto` (label + `TextFormField`), `CampoContrasena` (show/hide toggle), `CampoCodigo` (one digit per box), `CampoSelector<T>` (labeled dropdown), `CasillaAceptacion` (checkbox that is a `FormField<bool>`, so it validates with the form). All accept `validator`s and most a `habilitado` flag.
  - `auth/`: widgets specific to auth screens (`EncabezadoAuth`: logo in circle + title + subtitle).
- Styling is inherited from `AppTheme`: button styles (`filledButtonTheme`/`elevatedButtonTheme`/`textButtonTheme`), `inputDecorationTheme` (field fill/borders), `snackBarTheme` (floating), and `textTheme` (`headlineMedium`, `headlineSmall`, `titleMedium`, `bodyMedium`, `bodySmall`, `labelMedium`). Screens should use `Theme.of(context).textTheme.*`, themed buttons and plain `InputDecoration`s rather than inline `TextStyle`/`styleFrom`/borders.
- Static screen content (e.g. onboarding steps in `screens/onboarding/onboarding_pasos.dart`) lives as `const` model lists next to the screen, not in JSON.

Roles (from `assets/data/roles.json`): `1 comunidad`, `2 operador`, `3 punto_canje`, `4 administrador`, referenced by `Usuario.rolId` (constants `AppRol.comunidad`, etc.). Auth errors are deliberately generic ("Correo o contraseña incorrectos.", and password reset answers the same for unregistered emails) — don't reveal whether an email is registered. Registration is the one exception (it must say the email is taken). New accounts get role `AppRol.comunidad`.

Imports mix `package:circloop_movil/...` and relative paths; either is used in the codebase.
