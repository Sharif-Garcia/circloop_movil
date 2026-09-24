class AppStrings {
  // MARCA

  static const String nombreApp = 'CIRCLOOP';
  static const String eslogan = 'RECICLA. GANA. TRANSFORMA.';
  static const String descripcion = 'Sistema de Devolución y Recompensa';
  static const String piePlataforma = 'Plataforma Universitaria Sostenible v2.1';

  // ACCIONES

  static const String saltar = 'Saltar';
  static const String siguiente = 'Siguiente';
  static const String iniciarSesion = 'Iniciar sesión';
  static const String cerrarSesion = 'Cerrar sesión';

  // LOGIN

  static const String tituloLogin = 'Circloop';
  static const String subtituloLogin = 'Inicia sesión en tu cuenta';
  static const String correoInstitucional = 'Correo Institucional';
  static const String ejemploCorreo = 'usuario@unicesar.edu.co';
  static const String contrasena = 'Contraseña';
  static const String ejemploContrasena = '••••••••';
  static const String olvidasteContrasena = '¿Olvidaste tu contraseña?';
  static const String volver = 'Volver';
  static const String errorGeneral =
      'Ocurrió un error. Inténtalo de nuevo más tarde.';

  // RECUPERAR CONTRASEÑA

  static const String tituloRecuperar = 'Recuperar Contraseña';
  static const String subtituloRecuperar =
      'Ingresa tu correo para recibir las instrucciones de restablecimiento.';
  static const String correoRegistrado = 'Correo registrado';
  static const String enviarCodigo = 'Enviar Código';
  static const String codigoEnviado = 'Código Enviado';
  static const String codigoRecibido = 'Código de 4 dígitos enviado';
  static const String nuevaContrasena = 'Nueva Contraseña';
  static const String ejemploNuevaContrasena = 'Crea tu contraseña fuerte';
  static const String confirmarContrasena = 'Confirmar Nueva Contraseña';
  static const String ejemploConfirmarContrasena = 'Repite la contraseña';
  static const String restablecerContrasena = 'Restablecer Contraseña';
  static const String mensajeCodigoEnviado =
      'Si el correo está registrado, recibirás un código de 4 dígitos.';
  static String codigoDePrueba(String codigo) =>
      'Modo de prueba: tu código es $codigo';
  static const String codigoIncompleto =
      'Ingresa el código completo de 4 dígitos.';
  static const String codigoInvalido = 'El código es incorrecto o ha expirado.';
  static const String tituloContrasenaActualizada = '¡Contraseña Actualizada!';
  static const String mensajeContrasenaActualizada =
      'Tu contraseña ha sido restablecida con éxito. Ya puedes iniciar '
      'sesión con tus nuevas credenciales.';
  static const String irAlLogin = 'Ir al Login';

  // REGISTRO

  static const String tituloRegistro = 'Crear Cuenta';
  static const String subtituloRegistro =
      'Sé parte del cambio con CIRCLOOP en tu campus';
  static const String nombres = 'Nombres';
  static const String ejemploNombres = 'Ej. María José';
  static const String apellidos = 'Apellidos';
  static const String ejemploApellidos = 'Ej. Pérez Gómez';
  static const String ejemploContrasenaRegistro =
      'Mínimo 8 caracteres, letras y números';
  static const String confirmarContrasenaRegistro = 'Confirmar Contraseña';
  static const String carrera = 'Carrera Universitaria';
  static const String ejemploCarrera = 'Selecciona tu carrera';
  static const String cargandoCarreras = 'Cargando carreras...';
  static const String errorCarreras = 'No se pudieron cargar las carreras.';
  static const String seleccionaCarrera = 'Selecciona tu carrera.';
  static const String aceptoTerminos =
      'Acepto los términos de sostenibilidad y el reglamento de CIRCLOOP.';
  static const String crearCuenta = 'Crear mi cuenta';
  static const String yaTienesCuenta = '¿Ya tienes cuenta? ';
  static const String noTienesCuenta = '¿No tienes cuenta? ';
  static const String registrate = 'Regístrate';
  static const String correoYaRegistrado =
      'Este correo ya tiene una cuenta. Inicia sesión o recupera tu contraseña.';
  static const String tituloCuentaCreada = '¡Cuenta Creada!';
  static String mensajeCuentaCreada(String nombre) =>
      'Bienvenido a CIRCLOOP, $nombre. Ya puedes iniciar sesión con tu '
      'correo institucional.';

  static String bienvenida(String nombre) => '¡Bienvenido, $nombre!';

  // INICIO

  static String saludo(String nombre) => '¡Hola, $nombre!';
  static String rolActual(String rol) =>
      'Has iniciado sesión con el rol de: ${rol.toUpperCase()}';
  static const String descripcionPanel =
      'Desde aquí podrás gestionar las funciones correspondientes a tu rol '
      'dentro de la plataforma ecológico-académica Circloop.';
}
