class AppStrings {
  // MARCA

  static const String nombreApp = 'CIRCLOOP';
  static const String eslogan = 'RECICLA. GANA. TRANSFORMA.';
  static const String descripcion = 'Sistema de Devolución y Recompensa';
  static const String piePlataforma =
      'Plataforma Universitaria Sostenible v2.1';

  // ACCIONES

  static const String saltar = 'Saltar';
  static const String siguiente = 'Siguiente';
  static const String comenzar = 'Comenzar';
  static const String iniciarSesion = 'Iniciar sesión';
  static const String cerrarSesion = 'Cerrar sesión';

  // ONBOARDING

  static String pasoDe(int paso, int total) => 'Paso $paso de $total';

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
  static const String notificaciones = 'Notificaciones';
  static const String proximamente = 'Esta función estará disponible pronto.';
  static const String enConstruccion = 'Estamos construyendo esta sección.';
  static const String errorCargar = 'No se pudo cargar la información.';
  static String puntos(String cantidad) => '$cantidad pts';
  static String puntosGanados(int cantidad) => '+$cantidad pts';

  // NAVEGACIÓN

  static const String navInicio = 'Inicio';
  static const String navReciclaje = 'Reciclaje';
  static const String navCanjes = 'Canjes';
  static const String navExperiencia = 'Experiencia';
  static const String navPerfil = 'Perfil';

  // COMUNIDAD - INICIO

  static String nivel(int numero, String nombre) => 'Nivel $numero — $nombre';
  static String progresoXp(String actual, String meta) => '$actual / $meta XP';
  static String progresoNivel(int porcentaje, int siguiente, String nombre) =>
      '$porcentaje% completado para subir al nivel $siguiente ($nombre)';
  static const String nivelMaximo = '¡Alcanzaste el nivel máximo!';
  static const String reciclar = 'Reciclar';
  static const String escanearQr = 'Mi código QR';
  static const String canjear = 'Canjear';
  static const String misPremios = 'Mis Premios';
  static const String ranking = 'Ranking';
  static const String topCampus = 'Top Campus';
  static const String materialesReciclados = 'Materiales Reciclados';
  static const String emisionesEvitadas = 'Emisiones Evitadas';
  static const String actividadReciente = 'Actividad Reciente';
  static const String verHistorial = 'Ver Historial';
  static const String sinEntregas = 'Aún no tienes entregas';
  static const String sinEntregasMensaje =
      'Lleva tu material reciclable a una estación del campus y empieza a '
      'ganar puntos.';

  // RECICLAJE

  static const String entregas = 'Entregas';
  static const String pesoTotal = 'Peso Total';
  static const String esteMes = 'Este Mes';
  static const String todos = 'Todos';
  static const String misEntregas = 'Mis Entregas';
  static const String sinEntregasMaterial = 'Sin entregas de este material';
  static String sinEntregasMaterialMensaje(String material) =>
      'Aún no has reciclado $material. ¡Llévalo a una estación del campus!';
  static const String miCodigoQr = 'Mi Código QR';

  // CÓDIGO ECO-IDENTIFICADOR

  static const String codigoEcoIdentificador = 'Código Eco-Identificador';
  static const String acercarCodigo =
      'Muestra este código al lector de la estación o al operador.';
  static const String tuBalance = 'TU BALANCE';
  static const String tuNivel = 'TU NIVEL';
  static const String comoReciclarQr = '¿Cómo reciclar con tu QR?';
  static const List<String> pasosQr = [
    '1. Ubica una estación de reciclaje CIRCLOOP en tu facultad.',
    '2. Muestra este código en el lector de la estación o al operador.',
    '3. Deposita tus envases limpios y los puntos se suman solos.',
  ];

  // CANJES

  static const String todo = 'Todo';
  static const String tienes = 'Tienes';
  static const String paraCanjear = 'para canjear';
  static String elegibles(int cantidad) => '$cantidad elegibles';
  static const String catalogo = 'Catálogo';
  static const String misCanjes = 'Mis Canjes';
  static String faltanPuntos(String cantidad) => 'Faltan $cantidad pts';
  static const String popular = 'Popular';
  static const String nuevo = 'Nuevo';
  static const String sinPremios = 'No hay premios en esta categoría';
  static const String sinPremiosMensaje =
      'Pronto habrá nuevas recompensas. ¡Sigue reciclando!';
  static String confirmarCanjeTitulo(String premio) => '¿Canjear $premio?';
  static String confirmarCanjeMensaje(String costo, String quedan) =>
      'Se descontarán $costo puntos de tu balance y te quedarán $quedan. '
      'Recibirás un código para reclamar tu premio.';
  static const String cancelar = 'Cancelar';
  static const String confirmar = 'Confirmar';
  static const String puntosInsuficientes =
      'No tienes suficientes puntos para este premio. ¡Recicla más!';
  static const String agotado = 'Agotado';
  static String quedan(int cantidad) => 'Quedan $cantidad';
  static const String premioAgotado =
      'Este premio se agotó. Elige otro del catálogo.';
  static const String canjeExitosoTitulo = '¡Canje realizado!';
  static String canjeExitosoMensaje(String premio, String codigo) =>
      'Presenta el código $codigo en el establecimiento para reclamar: '
      '$premio. Lo encuentras en "Mis Canjes".';
  static const String verMisCanjes = 'Ver Mis Canjes';
  static const String entendido = 'Entendido';

  // TRANSFERIR PUNTOS

  static const String transferirPuntos = 'Transferir Puntos';
  static const String subtituloTransferir =
      'Envía puntos a otro miembro de la comunidad CIRCLOOP.';
  static const String disponiblesParaTransferir = 'disponibles para transferir';
  static const String correoDestinatario = 'Correo del destinatario';
  static const String cantidadPuntos = 'Cantidad de puntos';
  static const String ejemploCantidad = 'Ej. 100';
  static const String mensajeOpcional = 'Mensaje (opcional)';
  static const String ejemploMensaje =
      'Ej. Aporte para el proyecto de reciclaje';
  static String confirmarTransferenciaTitulo(String puntos) =>
      '¿Transferir $puntos puntos?';
  static String confirmarTransferenciaMensaje(
    String puntos,
    String correo,
    String quedan,
  ) =>
      'Enviarás $puntos puntos a $correo y te quedarán $quedan. '
      'Esta acción no se puede deshacer.';
  static const String transferenciaExitosaTitulo = '¡Transferencia exitosa!';
  static String transferenciaExitosaMensaje(String puntos, String correo) =>
      'Enviaste $puntos puntos a $correo.';
  static const String destinatarioNoExiste =
      'No hay ninguna cuenta con ese correo institucional.';
  static const String destinatarioNoValido =
      'Solo puedes transferir puntos a miembros activos de la comunidad.';
  static const String transferenciaASiMismo =
      'No puedes transferirte puntos a ti mismo.';
  static const String puntosInsuficientesTransferir =
      'No tienes suficientes puntos para esta transferencia.';

  // NOTIFICACIONES

  static const String subtituloNotificaciones =
      'Tus entregas, canjes, puntos recibidos y logros.';
  static const String marcarTodasLeidas = 'Marcar todas como leídas';
  static const String sinNotificaciones = 'No tienes notificaciones';
  static const String sinNotificacionesMensaje =
      'Aquí te avisaremos de tus entregas, canjes y logros.';
  static String noLeidas(int cantidad) =>
      cantidad == 1 ? '1 sin leer' : '$cantidad sin leer';
  static const String notifCanjeTitulo = 'Canje realizado';
  static String notifCanjeMensaje(
    String premio,
    String establecimiento,
    String codigo,
  ) => 'Presenta el código $codigo en $establecimiento para reclamar: $premio.';
  static const String notifTransferenciaTitulo = 'Recibiste puntos';
  static String notifTransferenciaMensaje(
    String remitente,
    String puntos,
    String? mensaje,
  ) =>
      '$remitente te envió $puntos puntos.'
      '${mensaje == null ? '' : ' Mensaje: "$mensaje"'}';

  // MIS CANJES

  static const String subtituloMisCanjes =
      'Presenta el código en el establecimiento para reclamar tu premio.';
  static const String sinCanjes = 'Aún no has canjeado premios';
  static const String sinCanjesMensaje =
      'Usa tus puntos en el catálogo para obtener recompensas.';
  static const String porReclamar = 'Por reclamar';
  static const String reclamado = 'Reclamado';
  static const String premioNoDisponible = 'Premio no disponible';
  static const String codigoCanje = 'Código de canje';

  // HISTORIAL

  static const String tituloHistorial = 'Historial de Entregas';
  static const String subtituloHistorial =
      'Todo el material que has reciclado en el campus.';
  static const String hoy = 'Hoy';
  static const String ayer = 'Ayer';

  // PERFIL

  static const String puntosDisponibles = 'Puntos Disponibles';
  static const String kgReciclados = 'Kg Reciclados';
  static const String puestoRanking = 'Puesto Ranking';
  static String puesto(int puesto) => '$puesto°';
  static const String sinPuesto = '—';
  static String insigniasLogradas(int logradas, int totales) =>
      'Insignias Logradas ($logradas/$totales)';
  static const String insigniaBloqueada = 'Aún no la has ganado';
  static const String editarPerfil = 'Editar Perfil';

  // EDITAR PERFIL

  static const String tituloEditarPerfil = 'Editar Perfil';
  static const String subtituloEditarPerfil =
      'Actualiza tus datos personales y académicos.';
  static const String guardarCambios = 'Guardar cambios';
  static const String perfilActualizado = 'Tu perfil se actualizó.';
}
