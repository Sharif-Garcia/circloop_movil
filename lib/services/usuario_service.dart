import 'dart:convert';

import 'package:circloop_movil/models/datos_registro.dart';
import 'package:circloop_movil/models/usuario.dart';
import 'package:circloop_movil/services/servicio_exception.dart';
import 'package:circloop_movil/utils/app_roles.dart';
import 'package:circloop_movil/utils/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UsuarioService {
  // El JSON de assets es de solo lectura: mientras no exista un backend,
  // los usuarios nuevos, los perfiles editados y las contraseñas cambiadas
  // se guardan en memoria (se pierden al cerrar la app).
  static final List<Usuario> _usuariosRegistrados = [];
  static final Map<int, Usuario> _perfilesActualizados = {};
  static final Map<String, String> _contrasenasActualizadas = {};

  @visibleForTesting
  static void reiniciarDatosEnMemoria() {
    _usuariosRegistrados.clear();
    _perfilesActualizados.clear();
    _contrasenasActualizadas.clear();
  }

  Future<List<Usuario>> obtenerUsuarios() async {
    final String respuesta = await rootBundle.loadString(
      'assets/data/usuarios.json',
    );

    final List<dynamic> datos = jsonDecode(respuesta);

    return [
      ...datos.map((dato) => Usuario.fromJson(dato)),
      ..._usuariosRegistrados,
    ].map((usuario) => _perfilesActualizados[usuario.id] ?? usuario).toList();
  }

  /// Guarda los cambios del usuario (perfil o puntos) y lo devuelve.
  Future<Usuario> actualizarUsuario(Usuario actualizado) async {
    // TODO: cuando exista el backend, enviar los cambios y devolver el
    // usuario que responda.
    _perfilesActualizados[actualizado.id] = actualizado;
    return actualizado;
  }

  Future<Usuario?> buscarPorCorreo(String correo) async {
    final buscado = _normalizar(correo);
    final usuarios = await obtenerUsuarios();

    for (final usuario in usuarios) {
      if (_normalizar(usuario.correoInstitucional) == buscado) {
        return usuario;
      }
    }

    return null;
  }

  Future<Usuario?> iniciarSesion(String correo, String contrasena) async {
    final usuario = await buscarPorCorreo(correo);

    if (usuario == null) {
      return null;
    }

    final contrasenaActual =
        _contrasenasActualizadas[_normalizar(correo)] ?? usuario.contrasena;

    if (contrasenaActual != contrasena || !usuario.activo) {
      return null;
    }

    return usuario;
  }

  /// Crea una cuenta con rol de comunidad.
  ///
  /// Lanza [ServicioException] si el correo ya está registrado.
  Future<Usuario> registrar(DatosRegistro datos) async {
    // TODO: cuando exista el backend, enviar `datos.toJson()` y devolver el
    // usuario que responda. Las validaciones del formulario y el manejo de
    // errores de la pantalla no necesitan cambios.
    if (await buscarPorCorreo(datos.correoInstitucional) != null) {
      throw const ServicioException(AppStrings.correoYaRegistrado);
    }

    final usuarios = await obtenerUsuarios();
    final siguienteId =
        usuarios.fold<int>(0, (max, u) => u.id > max ? u.id : max) + 1;

    final usuario = Usuario(
      id: siguienteId,
      nombres: datos.nombres,
      apellidos: datos.apellidos,
      correoInstitucional: _normalizar(datos.correoInstitucional),
      contrasena: datos.contrasena,
      carreraId: datos.carreraId,
      rolId: AppRol.comunidad,
      activo: true,
      puntosTotales: 0,
      puntosCanjeados: 0,
      puntosHistoricos: 0,
    );

    _usuariosRegistrados.add(usuario);
    return usuario;
  }

  Future<void> actualizarContrasena(
    String correo,
    String nuevaContrasena,
  ) async {
    // TODO: enviar al backend cuando exista.
    _contrasenasActualizadas[_normalizar(correo)] = nuevaContrasena;
  }

  String _normalizar(String correo) => correo.trim().toLowerCase();
}
