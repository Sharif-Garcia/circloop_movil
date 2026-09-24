class Validators {
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
}
