# Guía de construcción de CIRCLOOP (Flutter)

Eres un asistente que va a generar pantallas e interfaces para **CIRCLOOP**, una app móvil Flutter de la Universidad Popular del Cesar: un sistema de devolución de material reciclable y recompensas por puntos. El proyecto ya tiene una arquitectura, un sistema de diseño y widgets reutilizables definidos. **Todo el código que generes debe encajar en esta estructura sin romperla.** Lee esta guía completa antes de escribir código.

---

## 1. Tecnología

- **Flutter 3.44 / Dart 3.12**, Material 3.
- **Riverpod 3** (`flutter_riverpod`) para el estado. No usar `setState` para datos de negocio, ni `Provider`/`ChangeNotifier`/`StateNotifier`/`GetX`/`Bloc`.
- **Sin backend todavía**: los datos vienen de archivos JSON en `assets/data/`, leídos por servicios. Las escrituras se simulan en memoria.
- **Sin router**: navegación con `Navigator.push` / `pushReplacement` / `pop` y `MaterialPageRoute`.
- APIs actuales de Flutter: `color.withValues(alpha: 0.1)` (NO `withOpacity`), `super.key` (NO `Key? key` + `super(key: key)`), `DropdownButtonFormField(initialValue: ...)` (NO `value:`).

## 2. Idioma y nombres

- **Todo en español**: clases, métodos, variables, textos, comentarios. Ejemplos reales: `iniciarSesion`, `obtenerUsuarios`, `correoInstitucional`, `BotonPrimario`, `CampoTexto`, `_irAInicio`, `_cerrarSesion`.
- Excepción: los prefijos `App` de utilidades y widgets base (`AppColors`, `AppSizes`, `AppTarjeta`, `AppLogo`).
- Archivos en `snake_case`. Pantallas terminan en `_screen.dart` y la clase en `Screen` (`RegistroScreen`), **nunca** `View`.
- Providers terminan en `Provider` (`authProvider`), sus notifiers en `Notifier` (`RegistroNotifier`).
- Servicios terminan en `Service` (`UsuarioService`).

## 3. Estructura de carpetas

```
lib/
├── main.dart                 → runApp(ProviderScope(child: MyApp()))
├── app.dart                  → MaterialApp (tema, pantalla inicial)
├── models/                   → clases de datos inmutables con fromJson
├── services/                 → lectura/escritura de datos (JSON hoy, backend mañana)
├── providers/                → estado y lógica con Riverpod
├── screens/                  → pantallas, agrupadas por sección
│   ├── splash/
│   ├── onboarding/
│   ├── auth/                 → login, registro, recuperar contraseña, sesion.dart
│   ├── comunes/              → pantallas que sirven a todos los roles (perfil, notificaciones, en construcción)
│   ├── comunidad/            → panel del rol 1 (inicio, historial)
│   └── inicio/               → panel TEMPORAL de los roles que aún no tienen el suyo
├── utils/                    → tokens de diseño, tema, textos, validaciones, formatos
└── widgets/                  → widgets reutilizables, agrupados por tipo
    ├── comunes/
    ├── botones/
    ├── formularios/
    ├── navegacion/           → estructura de paneles (barra superior + pestañas)
    ├── auth/                 → widgets usados solo en pantallas de auth
    └── comunidad/            → widgets usados solo en el panel de comunidad
assets/
├── data/                     → JSON de datos de prueba
└── images/                   → imágenes (logo_original.png, cirk_transparente.png…)
test/
├── helpers/pruebas.dart      → utilidades compartidas de tests
└── <seccion>_test.dart
```

**Regla para secciones nuevas:** cada sección nueva de la app tiene su carpeta en `screens/<seccion>/` y, si tiene widgets propios que no sirven en otras secciones, en `widgets/<seccion>/`. Si un widget sirve en más de una sección, va en `comunes/`, `botones/` o `formularios/`.

## 4. Capas y responsabilidades

El flujo siempre es: **Pantalla → Provider → Service → JSON**. Una pantalla nunca lee JSON ni llama a un service directamente.

### models/
Clases inmutables (`final`), constructor con `required`, factory `fromJson`. Si se envían a un backend, `toJson`. Relaciones por id entero. Sin generación de código.

```dart
class Carrera {
  final int id;
  final String nombre;
  final int facultadId;

  Carrera({required this.id, required this.nombre, required this.facultadId});

  factory Carrera.fromJson(Map<String, dynamic> json) {
    return Carrera(
      id: json['id'],
      nombre: json['nombre'],
      facultadId: json['facultadId'],
    );
  }
}
```

Contenido estático de una pantalla (por ejemplo los pasos del onboarding) va como lista `const` de un modelo, en un archivo junto a la pantalla (`screens/onboarding/onboarding_pasos.dart`), no en JSON.

### services/
Un servicio por entidad. Lee `assets/data/<entidad>.json` con `rootBundle.loadString` + `jsonDecode`. Todo método es `Future`.

```dart
class CarreraService {
  Future<List<Carrera>> obtenerCarreras() async {
    final String respuesta = await rootBundle.loadString('assets/data/carreras.json');
    final List<dynamic> datos = jsonDecode(respuesta);
    return datos.map((dato) => Carrera.fromJson(dato)).toList();
  }
}
```

- Las escrituras (crear, actualizar) se simulan en memoria dentro del servicio con un `TODO` que indica dónde irá la llamada al backend. **El resto de la app no debe cambiar cuando llegue el backend.**
- Los errores esperados que el usuario debe ver se lanzan como `throw const ServicioException(AppStrings.algunMensaje)` (`services/servicio_exception.dart`). Cualquier otra excepción se trata como error inesperado.
- Si algo tendrá varias implementaciones (simulada / real), se define una interfaz abstracta y se expone con un `Provider` para poder cambiarla en una línea. Ejemplo existente: `services/codigo_verificacion/` + `codigoVerificacionServiceProvider`.

### providers/
- **Datos de solo lectura** (listas para mostrar): `FutureProvider`.
  ```dart
  final carrerasProvider = FutureProvider<List<Carrera>>((ref) async {
    final carreras = await CarreraService().obtenerCarreras();
    return carreras..sort((a, b) => a.nombre.compareTo(b.nombre));
  });
  ```
- **Lista cargada que además tiene acciones sobre sus elementos** (marcar leída, eliminar): `AsyncNotifierProvider.autoDispose` cuyo `build()` carga la lista y cuyos métodos actualizan `state` al instante y luego llaman al service (ver `notificacionesProvider`).
- **Acciones** (enviar un formulario, canjear, registrar): `NotifierProvider.autoDispose` con estado `AsyncValue<T?>`: `data(null)` = sin enviar, `loading` = procesando, `data(valor)` = éxito, `error(mensaje)` = falló.
  ```dart
  final registroProvider =
      NotifierProvider.autoDispose<RegistroNotifier, AsyncValue<Usuario?>>(
        RegistroNotifier.new,
      );

  class RegistroNotifier extends Notifier<AsyncValue<Usuario?>> {
    final UsuarioService _usuarioService = UsuarioService();

    @override
    AsyncValue<Usuario?> build() => const AsyncValue.data(null);

    Future<void> registrar(DatosRegistro datos) async {
      state = const AsyncValue.loading();
      try {
        final usuario = await _usuarioService.registrar(datos);
        if (!ref.mounted) return;
        state = AsyncValue.data(usuario);
      } on ServicioException catch (e, stackTrace) {
        if (!ref.mounted) return;
        state = AsyncValue.error(e.mensaje, stackTrace);
      } catch (e, stackTrace) {
        if (!ref.mounted) return;
        state = AsyncValue.error(AppStrings.errorGeneral, stackTrace);
      }
    }
  }
  ```
- Flujos de varios pasos: una clase de estado inmutable con `copyWith` y un `enum` de pasos (ver `EstadoRecuperacion` en `recuperar_contrasena_provider.dart`).
- Siempre `if (!ref.mounted) return;` después de cada `await` antes de asignar `state`.

### Usuario en sesión
`authProvider` (`providers/auth_provider.dart`) es `AsyncValue<Usuario?>`. Para obtener el usuario logueado en cualquier pantalla:
```dart
final usuario = ref.watch(authProvider).value; // Usuario? — null si no hay sesión
```
Cerrar sesión: `ref.read(authProvider.notifier).cerrarSesion();`

### screens/
Plantilla de una pantalla con formulario o acción:

```dart
class EjemploScreen extends ConsumerStatefulWidget {
  const EjemploScreen({super.key});

  @override
  ConsumerState<EjemploScreen> createState() => _EjemploScreenState();
}

class _EjemploScreenState extends ConsumerState<EjemploScreen> {
  final _formKey = GlobalKey<FormState>();
  final _campoController = TextEditingController();

  @override
  void dispose() {
    _campoController.dispose();
    super.dispose();
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(ejemploProvider.notifier).enviar(_campoController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(ejemploProvider);

    // Efectos (mensajes, diálogos, navegación) SIEMPRE en ref.listen, nunca en build
    ref.listen(ejemploProvider, (anterior, actual) {
      actual.whenOrNull(
        data: (resultado) { if (resultado != null) { /* diálogo o navegación */ } },
        error: (error, _) => AppMensaje.error(context, error.toString()),
      );
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const EncabezadoSeccion(titulo: AppStrings.x, subtitulo: AppStrings.y),
                const SizedBox(height: AppSizes.lg),
                // ... widgets reutilizables ...
                BotonPrimario(texto: AppStrings.z, onPressed: _enviar, cargando: estado.isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- Pantallas sin estado local: `ConsumerWidget`. Sin Riverpod: `StatelessWidget`/`StatefulWidget`.
- Una pantalla **solo arma piezas**: no define estilos, colores, bordes ni textos sueltos.
- Métodos privados con verbo en español: `_enviar`, `_irAInicio`, `_volverAlLogin`, `_abrir(Widget pantalla)`.
- Una sección de la pantalla que sea larga se puede extraer a un método privado `Widget _campoCarrera()` o, si se reutiliza, a un widget en `widgets/`.

## 5. Sistema de diseño (NO inventar valores)

### Colores — `AppColors` (`utils/app_colors.dart`)
| Token | Valor | Uso |
|---|---|---|
| `primary` | `#006948` | Verde principal: botones, enlaces, íconos de marca |
| `primaryDark` | `#1B4D1E` | Títulos grandes |
| `secondary` | `#00687A` | Azul petróleo (rol operador, acentos) |
| `tertiary` | `#A36700` | Ámbar (rol punto de canje, puntos/recompensas) |
| `background` | `#FAF8FF` | Fondo de pantallas |
| `surface` | `#FFFFFF` | Tarjetas, diálogos |
| `textPrimary` / `textSecondary` | `#131B2E` / `#3D4A42` | Textos |
| `success` / `warning` / `error` / `info` | `#2E7D32` / `#F59E0B` / `#BA1A1A` / `#00687A` | Estados y mensajes |
| `border` / `borderVariant` | `#E2E8F0` / `#BCCAC0` | Bordes |
| `grey` / `greyLight` / `greyDark` | `#667085` / `#F1F5F9` / `#475467` | Textos secundarios, rellenos |
| `white` / `black` | | |

Si hace falta un color nuevo, se **agrega a `AppColors`** con nombre semántico; nunca `Color(0xFF...)` ni `Colors.green` dentro de una pantalla o widget.

### Tamaños — `AppSizes` (`utils/app_sizes.dart`)
- Espaciado: `xs 4`, `sm 8`, `md 16`, `lg 24`, `xl 32`, `xxl 48`. Padding de pantalla: `AppSizes.lg`. Separación entre campos: `AppSizes.md`.
- Radios: `radiusSm 6`, `radiusMd 10` (botones, campos), `radiusLg 16` (tarjetas, diálogos), `radiusXl 24`.
- Íconos: `iconSm 18`, `iconMd 24`, `iconLg 32`, `iconXl 40`, `iconXxl 100`.
- Imágenes: `logoSm 32`, `logoMd 64`, `logoLg 140`, `ilustracion 220`.
- Texto: `textXs 12`, `textLabel 13`, `textSm 14`, `textMd 16`, `textLg 20`, `textXl 24`, `textTitle 28`, `textXxl 32`.
- Otros: `buttonHeight 50`, `casillaCodigo 56`, `indicadorAlto 8`, `indicadorAnchoActivo 24`.

Si hace falta un tamaño nuevo, se agrega a `AppSizes`. Nada de números sueltos (`EdgeInsets.all(20)`, `height: 12`) en pantallas.

### Tema global — `AppTheme` (`utils/app_theme.dart`)
Los widgets **heredan** el estilo del tema; no se repite en cada pantalla:
- `FilledButton` / `ElevatedButton`: verde, ancho completo, alto 50, radio 10, texto 16 negrita.
- `TextButton`: gris con peso 600 (para verde: `TextButton.styleFrom(foregroundColor: AppColors.primary)`).
- `InputDecoration`: relleno `greyLight`, borde `border`, borde verde de 1.5 al enfocar, borde rojo en error. En pantallas se usa `InputDecoration(hintText: ..., prefixIcon: ...)` sin bordes ni colores.
- `SnackBar` flotante; diálogos blancos con radio 16.
- `AppBar` blanca sin sombra con íconos verdes; `NavigationBar` (pestañas inferiores) blanca con indicador verde claro.
- Textos: usar `Theme.of(context).textTheme`:
  | Estilo | Aspecto | Uso |
  |---|---|---|
  | `headlineMedium` | 32, negrita, primaryDark | Título grande (login) |
  | `headlineSmall` | 24, negrita, primaryDark | Título de pantalla |
  | `titleLarge` | 20, negrita, primaryDark | Título de bloque ("Actividad Reciente") |
  | `titleMedium` | 20, negrita, primary | Nombre de marca, subtítulos destacados |
  | `titleSmall` | 16, negrita, textPrimary | Título de ítem de lista, valores destacados |
  | `bodyMedium` | 14, gris, interlineado 1.4 | Descripciones |
  | `bodySmall` | 12, gris | Pies, notas |
  | `labelMedium` | 13, 600, gris | Etiquetas de campos |

  Si se necesita una variación: `textos.bodyMedium?.copyWith(color: AppColors.primary)`. Si un estilo se repite, se agrega al `textTheme`.

### Textos — `AppStrings` (`utils/app_strings.dart`)
**Todo texto visible** va en `AppStrings`, agrupado por sección con comentarios (`// LOGIN`, `// REGISTRO`…). Textos con datos: funciones estáticas.
```dart
static const String tituloRegistro = 'Crear Cuenta';
static String bienvenida(String nombre) => '¡Bienvenido, $nombre!';
```

### Imágenes — `AppImages` (`utils/app_images.dart`)
Rutas de `assets/images/` como constantes (`AppImages.logo`, `AppImages.mascota`). Se muestran con `AppImagen`, que pone un ícono de respaldo si el archivo aún no existe.

### Validaciones — `Validators` (`utils/validators.dart`)
Funciones estáticas `String? Function(String?)` que devuelven el mensaje de error en español o `null`: `correo`, `contrasena`, `correoInstitucional` (termina en `@unicesar.edu.co`), `nombre`, `contrasenaNueva` (mín. 8, letras y números), `confirmarContrasena(() => otroController.text)`, `seleccionRequerida<T>(mensaje)`, `aceptarTerminos`, `cantidadPuntos(disponibles)` (entero entre 1 y lo disponible), `textoMaximo(n)` (campo opcional con límite de caracteres). Reglas nuevas se agregan aquí; los errores de formulario se muestran **debajo del campo** (validator), no en SnackBar.

### Roles — `AppRol` (`utils/app_roles.dart`)
| id | Rol | Constante | Color | Ícono |
|---|---|---|---|---|
| 1 | Comunidad (estudiantes y comunidad universitaria) | `AppRol.comunidad` | `primary` | `Icons.school` |
| 2 | Operador | `AppRol.operador` | `secondary` | `Icons.engineering` |
| 3 | Punto de canje | `AppRol.puntoCanje` | `tertiary` | `Icons.store` |
| 4 | Administrador | `AppRol.administrador` | `primaryDark` | `Icons.admin_panel_settings` |

`AppRol.porId(usuario.rolId)` devuelve `nombre`, `tituloPanel`, `icono`, `color`.

## 6. Widgets reutilizables existentes (usarlos SIEMPRE antes de crear otros)

### `widgets/comunes/`
| Widget | Uso |
|---|---|
| `AppTarjeta(child:, padding:)` | Contenedor blanco, borde, radio 16, sombra suave |
| `EncabezadoSeccion(titulo:, subtitulo:)` | Título + subtítulo alineados a la izquierda |
| `AppImagen(ruta:, altura:, iconoRespaldo:)` | Imagen LOCAL de la marca (logo, mascota) con ícono de respaldo |
| `ImagenRemota(url:, altura:, iconoRespaldo:, colorRespaldo:, llenarAncho:)` | Imagen que viene de la base de datos (URL): indicador mientras carga e ícono si no hay URL o falla |
| `CodigoQr(codigo:, tamano:)` | QR con colores de marca y marco verde (spinner si `codigo` es null). Único lugar que dibuja QR |
| `AppLogo(altura:)` | Logo de CIRCLOOP |
| `AppMarca()` | Logo pequeño + "CIRCLOOP" en fila (encabezados) |
| `IndicadorPaginas(total:, actual:)` | Puntos de progreso animados |
| `AppMensaje.exito/error/aviso/info(context, texto)` | SnackBar con color según tipo |
| `mostrarDialogoExito(context, titulo:, mensaje:, textoBoton:, alAceptar:)` | Diálogo de éxito con un botón |
| `await mostrarDialogoConfirmacion(context, titulo:, mensaje:)` → `bool` | Pregunta Cancelar/Confirmar antes de una acción importante |
| `AvatarUsuario(usuario:, diametro:)` | Foto del usuario o sus iniciales |
| `Etiqueta(texto:, color:, icono:)` | Pastilla de color (puntos, nivel, estado, rol) |
| `IndicadorEstadistica(icono:, color:, valor:, descripcion:)` | Ícono + número destacado + descripción |
| `TituloSeccion(titulo:, accion:, onAccion:)` | Título de bloque con enlace opcional ("Ver Historial") |
| `ItemLista(icono:, color:, titulo:, subtitulo:, extremo:, onTap:)` | Fila en tarjeta para cualquier lista (historial, premios, notificaciones) |
| `EstadoVacio(icono:, titulo:, mensaje:, accion:)` | Lista vacía, error de carga o sección pendiente |
| `TarjetaDato(icono:, color:, valor:, descripcion:)` | Dato destacado en vertical; en fila con `Expanded` (resúmenes, perfil) |
| `TarjetaPerfil(usuario:, detalle:, etiqueta:)` | Avatar grande + nombre + correo + dato extra + etiqueta |
| `TarjetaResumen(datos: [DatoResumen(valor:, descripcion:, color:)])` | Varios valores en fila separados por líneas ("6 Entregas \| 14,5 kg \| +230 pts") |
| `TarjetaAviso(titulo:, lineas:, icono:, color:)` | Recuadro teñido con instrucciones o consejos |

### `widgets/botones/`
| Widget | Uso |
|---|---|
| `BotonPrimario(texto:, onPressed:, cargando:)` | Botón principal ancho completo; `onPressed: null` lo deshabilita; `cargando` muestra spinner |
| `BotonVolver(onPressed:)` | "< Volver" (por defecto `Navigator.maybePop`) |
| `EnlaceTexto(texto:, accion:, onPressed:)` | "¿Ya tienes cuenta? **Inicia sesión**" (usa `Wrap`, no se desborda) |
| `BotonAccion(titulo:, subtitulo:, icono:, color:, onPressed:)` | Acción rápida en tarjeta teñida; se usa en fila con `Expanded` en el inicio de cualquier rol |
| `BotonSecundario(texto:, onPressed:, icono:, color:)` | Botón con borde, ancho completo ("Editar Perfil"; con `color: AppColors.error` para "Cerrar Sesión") |

### `widgets/navegacion/` (estructura de los paneles de TODOS los roles)
| Widget | Uso |
|---|---|
| `PanelNavegacion(barraSuperior:, secciones: [SeccionPanel(...)])` | Scaffold con pestañas inferiores; conserva el estado de cada pestaña. Cambiar de pestaña desde dentro: `PanelNavegacion.of(context).irA(indice)` |
| `SeccionPanel(etiqueta:, icono:, iconoActivo:, pantalla:, botonFlotante:)` | Una pestaña. Si necesita botón flotante, va en `botonFlotante` (NO un `Scaffold` dentro de la pestaña: los mensajes lo taparían) |
| `BarraSuperior(usuario:, puntos:, pestanaPerfil:)` | Avatar + CIRCLOOP; puntos opcionales (solo comunidad) y campana con globo de no leídas que abre `NotificacionesScreen`; tocar el avatar va a la pestaña `pestanaPerfil` |

**Panel de un rol nuevo:** crear `screens/<rol>/panel_<rol>_screen.dart` que devuelva `PanelNavegacion` con sus pestañas (ver `PanelComunidadScreen`), agregar su caso en `pantallaInicioPorRol` (`screens/auth/sesion.dart`) y usar `EnConstruccionScreen(titulo:, icono:)` para pestañas pendientes. Para cerrar sesión: `cerrarSesion(context, ref)` de `sesion.dart`.

**Perfil:** hay UN solo perfil para todos los roles, `PerfilScreen` (`screens/comunes/`), que ya trae la tarjeta del usuario, "Editar Perfil" (`EditarPerfilScreen`) y "Cerrar Sesión". Cada rol agrega lo suyo con `PerfilScreen(contenidoRol: MiSeccion())`. Ejemplo: comunidad pasa `ResumenPerfilComunidad()` (puntos, kg, ranking, insignias). No crear otra pantalla de perfil por rol.

### `widgets/comunidad/`
`TarjetaNivel(xp:)`, `TarjetaImpacto(progreso:)`, `ItemEntrega(entrega:)`, `CuadriculaInsignias(insignias:)`, `ResumenPerfilComunidad()`, `BotonCodigoQr()`, `TarjetaPremio(premio:, puntosDisponibles:, onCanjear:, cargando:)`, `TarjetaPuntos(puntos:, descripcion:, extremo:)` ("Tienes 1.100 pts para canjear / disponibles para transferir").

**Pestañas: el contenido de una pestaña NO lleva `Scaffold` ni `AppBar`** (los pone `PanelNavegacion`). Solo las pantallas que se abren con `push` encima del panel (historial, código QR, editar perfil) tienen su propio `Scaffold` con `BotonVolver`.

### `widgets/formularios/`
| Widget | Uso |
|---|---|
| `CampoTexto(etiqueta:, ejemplo:, icono:, controller:, validator:, keyboardType:, habilitado:, sufijo:, lineas:, formateadores:)` | Etiqueta + `TextFormField`; `lineas: 2` para mensajes; `formateadores: [FilteringTextInputFormatter.digitsOnly]` para solo números |
| `CampoContrasena(etiqueta:, ejemplo:, controller:, validator:, habilitado:)` | Con botón mostrar/ocultar |
| `CampoCodigo(longitud:, onChanged:, habilitado:)` | Casillas de un dígito |
| `CampoSelector<T>(etiqueta:, ejemplo:, opciones:, textoOpcion:, valor:, onChanged:, validator:, icono:, habilitado:)` | Lista desplegable |
| `CasillaAceptacion(texto:, validator:, onChanged:)` | Checkbox que valida con el `Form` |
| `SelectorChips<T>(opciones:, textoOpcion:, seleccion:, onChanged:, textoTodos:)` | Filtros en chips con scroll horizontal; `textoTodos` agrega "Todos" (= `null`) |

### `widgets/auth/`
`EncabezadoAuth(titulo:, subtitulo:)`: logo en círculo verde claro + título + subtítulo.

**Cómo escribir un widget nuevo:** `StatelessWidget` salvo que tenga estado visual propio; parámetros `final` en español; constructor `const` con `super.key`; comentario `///` de una línea explicando para qué sirve; estilos desde `AppColors`/`AppSizes`/`textTheme`; imports relativos (`'../../utils/app_sizes.dart'`).

## 7. Datos disponibles

`assets/data/usuarios.json` → modelo `Usuario`:
```
id, nombres, apellidos, correoInstitucional, contrasena, carreraId (int?),
rolId, activo, puntosTotales, puntosCanjeados, puntosHistoricos, fotoUrl (String?)
```
Usuarios de prueba (contraseña `123456`): `anatorres@unicesar.edu.co` (Ana, comunidad), `julianrios@unicesar.edu.co` (Julián, comunidad), `carlosperez@unicesar.edu.co` (operador), `lauragomez@unicesar.edu.co` (punto de canje), `admin@unicesar.edu.co` (administrador).

También existen `carreras.json` (23 carreras, `carrerasProvider`, `carreraUsuarioProvider` = carrera del usuario en sesión), `facultades.json` (`facultadesProvider`), `roles.json` y `entregas.json` (entregas de material: `Entrega` con `material`, `pesoKg`, `co2EvitadoKg`, `puntos`, `fecha`; `entregasUsuarioProvider` = entregas del usuario en sesión, más recientes primero).

- Los datos se guardan **crudos** (números, fechas ISO, claves como `"plastico"`); la pantalla los formatea. Nunca guardar textos ya armados como `"Hoy, 10:45 AM"` o `"1.2 kg"`.
- `Formatos` (`utils/formatos.dart`): `entero(1250)` → "1.250", `kilos(14.5)` → "14,5 kg", `fechaRelativa(fecha)` → "Hoy, 10:45 AM" / "Ayer, 4:20 PM" / "18 Sep, 11:15 AM".
- `AppMaterial.porClave('plastico')` (`utils/app_materiales.dart`): `nombre`, `nombreCorto` (para filtros), ícono y color de cada material; `AppMaterial.claves` = todos (plastico, papel, vidrio, aluminio, organico). No crear otras listas de materiales.
- Código Eco-Identificador (QR personal que escanea el operador): `EcoIdentificadorService` (`obtenerCodigo(usuario)` → "CIRC-000001"; `idDesdeCodigo(codigo)` para el lado del operador) y `ecoIdentificadorProvider`. Se dibuja con `QrImageView` del paquete `qr_flutter`, nunca con una imagen fija.
- `NivelEco` (`models/nivel_eco.dart`): niveles de gamificación por XP (= `puntosHistoricos`): `NivelEco.paraXp(xp)`, `.siguiente`, `.progreso(xp)`.
- `ProgresoEco.desde(usuario, entregas)` (`models/progreso_eco.dart`): totales de kg, CO₂, entregas por material y nivel. Es la ÚNICA fuente de esos cálculos; `progresoUsuarioProvider` lo expone para el usuario en sesión.
- `insignias.json` define cada insignia con su **regla** (`criterio`: entregas | kg | co2 | material | nivel, y `meta`), nunca con "lograda: true". `Insignia.lograda(progreso)` decide; `insigniasUsuarioProvider` devuelve `({Insignia insignia, bool lograda})`. Íconos por nombre desde JSON: `AppIconos.porNombre('eco')`.
- Ranking: `rankingComunidadProvider` (usuarios comunidad por `puntosHistoricos`) y `puestoRankingProvider` (puesto del usuario en sesión).
- **Todo el contenido viene de la base de datos**, aunque hoy se simule con JSON: imágenes (`imagenUrl`, mostradas con `ImagenRemota`), stock, disponibilidad (`activo`), precios, etc. Nada de contenido se guarda como archivo local en `assets/images/`; allí solo van imágenes fijas de la marca (logo, mascota).
- Canjes: `premios.json` → `Premio` (categoria = clave de `AppCategoriaPremio`: comida, merchandise, experiencias; `imagenUrl`; `etiqueta` "popular"/"nuevo"; `stock` con `null` = ilimitado y getters `agotado`/`quedanPocos`; `activo: false` = retirado, no se muestra) → `premiosProvider`. El canje valida stock y puntos, y descuenta ambos. `canjes.json` → `Canje` (`codigo` "CJ-XXXXXX", `estado` pendiente/entregado) → `canjesUsuarioProvider` (con su premio). `CanjeService.canjear(usuario, premio)` valida puntos (`ServicioException` si no alcanzan), descuenta `puntosTotales`, suma `puntosCanjeados` y genera el código; `canjearProvider` lo ejecuta y actualiza el usuario en sesión. El código de canje lo escaneará el rol punto de canje.
- Notificaciones (todos los roles): `notificaciones.json` → `Notificacion` (`tipo` = clave de `AppTipoNotificacion`: entrega, canje, transferencia, insignia, sistema; `leida`) → `NotificacionService` → `notificacionesProvider` (un `AsyncNotifier`: la lista + `marcarLeida`/`marcarTodasLeidas`) y `notificacionesNoLeidasProvider` (contador de la campana). Pantalla: `NotificacionesScreen` (`screens/comunes/`). **Cuando una acción le interese a un usuario, el service que la hace crea la notificación** con `NotificacionService().crear(usuarioId:, tipo:, titulo:, mensaje:)` (hoy lo hacen `CanjeService` y `TransferenciaService`; lo hará el registro de entregas del operador). Con backend, las crea el servidor.
- Transferir puntos: `TransferenciaService.transferir(remitente:, correoDestino:, puntos:, mensaje:)` valida (destinatario existe, es de la comunidad, está activo, no es uno mismo, alcanzan los puntos; `ServicioException` si no), mueve solo `puntosTotales` (los históricos/XP no se transfieren) y devuelve el remitente actualizado; `transferirProvider` lo ejecuta y actualiza la sesión. Pantalla: `TransferirPuntosScreen`, desde la pestaña Canjes. Las validaciones de formato van en el formulario (`Validators`) y las de negocio se repiten en el service (y deberán repetirse en el backend).
- Editar perfil: `UsuarioService.actualizarUsuario` (en memoria, con `TODO` de backend) + `editarPerfilProvider`, que al guardar llama a `authProvider.notifier.actualizarUsuario(usuario)` para que toda la app muestre los datos nuevos.

**Datos nuevos** (materiales, estaciones, recompensas, historial de entregas…): crear `assets/data/<entidad>.json` + `models/<entidad>.dart` + `services/<entidad>_service.dart` + provider. La carpeta `assets/data/` ya está registrada en `pubspec.yaml`.

## 8. Navegación actual

`SplashScreen` (3 s) → `OnboardingScreen` → `LoginScreen` → `pantallaInicioPorRol(usuario)`.
- Desde el login se abren con `push` `RecuperarContrasenaScreen` y `RegistroScreen` (regresan con `pop`).
- `pantallaInicioPorRol` (`screens/auth/sesion.dart`): rol 1 → `PanelComunidadScreen`; los demás → `InicioRolScreen` (panel **temporal** hasta que tengan el suyo).
- `PanelComunidadScreen` tiene 5 pestañas: Inicio (`InicioComunidadScreen`), Reciclaje, Canjes y Experiencia (en construcción) y Perfil (`PerfilScreen`). Sus índices están en `PestanaComunidad`. "Ver Historial" abre `HistorialEntregasScreen` con `push`.

## 9. Lo que NO se debe hacer

- ❌ `AppTheme.primaryGreen`, `AppTheme.textGrey`, carpetas `theme/`, `ui/`, `data/mock_users.dart`: **no existen**. Los colores están en `AppColors` y el tema en `utils/app_theme.dart`.
- ❌ Clases `...View`, `LoginView`, `MockUsers`, `UserProfile`: se llaman `...Screen`, `UsuarioService`, `Usuario`.
- ❌ Colores, tamaños o textos escritos directamente en pantallas o widgets.
- ❌ `ElevatedButton.styleFrom(...)`, `OutlineInputBorder(...)`, `BoxDecoration` repetidos en pantallas: ya están en el tema o en un widget.
- ❌ Métodos helper como `_inputDecoration()` o `_buildLabel()` dentro de una pantalla: si algo se repite, es un widget en `widgets/`.
- ❌ Leer JSON o llamar servicios desde una pantalla.
- ❌ Mostrar SnackBars, diálogos o navegar dentro de `build`: van en `ref.listen` o en callbacks.
- ❌ Mensajes que revelen si un correo está registrado en login o en recuperación de contraseña (solo el registro puede decir "este correo ya tiene una cuenta").
- ❌ Poner credenciales, claves de API o datos de correo dentro de la app.
- ❌ `withOpacity`, `Key? key`, `DropdownButtonFormField(value:)`, `BottomNavigationBar` (se usa `PanelNavegacion`), `StateProvider` (es legacy en Riverpod 3: para un filtro de una pantalla usar estado local con `setState`; para estado compartido, un `Notifier`).
- ❌ Crear un modelo o JSON nuevo para datos que ya existen (por ejemplo `EntregaReciclaje` cuando ya está `Entrega`): se reutiliza el modelo, su provider y su widget de lista.
- ❌ Imágenes "placeholder" para cosas que se pueden generar (códigos QR, gráficas).
- ❌ `Image.network` o `Image.asset` sueltos: imágenes de contenido (premios, usuarios, estaciones…) llegan como URL desde la base de datos y se muestran con `ImagenRemota`; solo el logo y la mascota son locales (`AppImagen`).
- ❌ Validaciones solo en la pantalla: las de formato van en `Validators` (formulario) y las de negocio (saldo, stock, destinatario válido) en el service con `ServicioException`.
- ❌ Datos de contenido en `AppStrings` (nombres de premios, establecimientos, materiales): van en el JSON. `AppStrings` es solo para textos de la interfaz.
- ❌ Acciones que solo muestran "¡Listo!" sin cambiar nada (un canje que no descuenta puntos): toda acción pasa por su service, actualiza los datos y, si afecta al usuario, llama a `authProvider.notifier.actualizarUsuario`.
- ❌ Clases que no existen: revisar la sección 6 antes de usar un widget (`AppBotonPrimario` → es `BotonPrimario`) y la sección 5 antes de usar un color (`AppColors.surfaceVariant` no existe).
- ❌ Datos de ejemplo escritos en la pantalla (`'14.5 kg'`, `'Nivel 3'`, `usuario?.nombres ?? 'María'`): todo sale del usuario en sesión o de un provider.
- ❌ Botones que hacen algo distinto a lo que dicen (por ejemplo una campana que cierra sesión). Si la función no existe aún: `AppMensaje.info(context, AppStrings.proximamente)` con un `TODO`.
- ❌ Un `Row` con textos sin `Expanded`/`Flexible`: en pantallas angostas se desborda.
- ❌ Datos "de resultado" en JSON que deberían calcularse (insignias `"lograda": true`, puesto de ranking fijo, totales de kg): se guardan las reglas o los datos crudos y la app calcula.
- ❌ Abrir con `push` una pantalla que ya es una pestaña del panel (por ejemplo el perfil): se cambia de pestaña con `PanelNavegacion.of(context).irA(indice)`.

## 10. Tests

Cada sección nueva lleva `test/<seccion>_test.dart` usando `test/helpers/pruebas.dart`:
```dart
void main() {
  configurarPruebas(); // limpia caché de JSON y datos en memoria entre tests

  testWidgets('descripción en español', (tester) async {
    await abrirPantalla(tester, const EjemploScreen());
    await esperarA(tester, find.text(AppStrings.algo)); // espera cargas asíncronas del JSON
    expect(find.text(AppStrings.algo), findsOneWidget);
  });
}
```
Buscar textos con `AppStrings`/`Validators` (no copiar mensajes a mano). Para simular un usuario logueado se puede hacer login en el test con `iniciarSesion(tester, correo:, contrasena:, esperado:)`.

Comandos: `flutter analyze` (debe decir "No issues found!") y `flutter test`.

## 11. Formato de respuesta esperado

Cuando generes una interfaz:
1. Indica **la ruta de cada archivo** (`lib/screens/comunidad/inicio_comunidad_screen.dart`) y entrega el archivo completo.
2. Lista lo que se agrega a archivos existentes (`AppStrings`, `AppSizes`, `AppColors`, `AppImages`, `Validators`) como fragmentos para pegar en su sección.
3. Reutiliza los widgets de la sección 6; si creas uno nuevo, explica por qué ninguno existente sirve y en qué carpeta va.
4. Si la interfaz necesita datos que aún no existen, entrega también el JSON de prueba, el modelo, el servicio y el provider.
5. Indica qué imágenes nuevas hay que poner en `assets/images/` y con qué nombre.

---

## Estado actual del rol 1 (Comunidad)

Ya existen las pestañas **Inicio** (saludo, nivel, acciones rápidas, impacto, actividad reciente), **Reciclaje** (resumen, entregas filtrables por material y botón "Mi Código QR" → `CodigoQrScreen`) **Canjes** (puntos, transferir puntos, catálogo filtrable con stock, canje con confirmación y código, "Mis Canjes" con QR) y **Perfil** (datos, puntos, ranking, insignias, editar perfil), además del **historial**. Solo **Experiencia** muestra `EnConstruccionScreen`; para implementarla, crear su pantalla en `screens/comunidad/` y reemplazarla en la lista de `secciones` de `PanelComunidadScreen` (para el ranking ya existe `rankingComunidadProvider`).
- Datos del usuario: `ref.watch(authProvider).value` → `nombres`, `puntosTotales` (disponibles), `puntosCanjeados`, `puntosHistoricos` (XP), `carreraId`, `fotoUrl`.
- Color de acento del rol: `AppColors.primary`; puntos/recompensas: `AppColors.tertiary`.
- Los datos de otras pantallas (premios, estaciones, ranking…) necesitan su JSON + modelo + servicio + provider, como `entregas.json`.
