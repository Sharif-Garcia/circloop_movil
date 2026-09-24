class Validators {
  static const String dominioInstitucional = '@unicesar.edu.co';
  static const int longitudMinimaContrasena = 8;
  static const int longitudMinimaNombre = 2;

  static final RegExp _soloLetras = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ' ]+$");
  static final RegExp _tieneLetra = RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ]');
  static final RegExp _tieneNumero = RegExp(r'\d');

  static String? correo(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Ingresa tus credenciales.';
    }

    return null;
  }

  static String? contrasena(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Ingresa tus credenciales.';
    }

    return null;
  }

  static String? correoInstitucional(String? valor) {
    final correo = valor?.trim().toLowerCase() ?? '';

    if (correo.isEmpty || !correo.endsWith(dominioInstitucional)) {
      return 'Ingresa un correo institucional válido ($dominioInstitucional).';
    }

    if (correo.length == dominioInstitucional.length) {
      return 'Escribe tu usuario antes de $dominioInstitucional.';
    }

    return null;
  }

  static String? nombre(String? valor) {
    final nombre = valor?.trim() ?? '';

    if (nombre.isEmpty) {
      return 'Este campo es obligatorio.';
    }

    if (nombre.length < longitudMinimaNombre) {
      return 'Debe tener al menos $longitudMinimaNombre letras.';
    }

    if (!_soloLetras.hasMatch(nombre)) {
      return 'Solo se permiten letras y espacios.';
    }

    return null;
  }

  static String? contrasenaNueva(String? valor) {
    if (valor == null || valor.length < longitudMinimaContrasena) {
      return 'La contraseña debe tener al menos '
          '$longitudMinimaContrasena caracteres.';
    }

    if (!_tieneLetra.hasMatch(valor) || !_tieneNumero.hasMatch(valor)) {
      return 'La contraseña debe combinar letras y números.';
    }

    return null;
  }

  /// Devuelve un validador que compara con el valor actual de [original].
  static String? Function(String?) confirmarContrasena(
    String Function() original,
  ) {
    return (valor) {
      if (valor == null || valor.isEmpty) {
        return 'Confirma tu contraseña.';
      }

      if (valor != original()) {
        return 'Las contraseñas no coinciden.';
      }

      return null;
    };
  }

  /// Validador para listas desplegables obligatorias.
  static String? Function(T?) seleccionRequerida<T>(String mensaje) {
    return (valor) => valor == null ? mensaje : null;
  }

  static String? aceptarTerminos(bool? valor) {
    if (valor != true) {
      return 'Debes aceptar los términos para continuar.';
    }

    return null;
  }
}
