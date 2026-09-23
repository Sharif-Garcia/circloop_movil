import 'package:circloop_movil/services/carrera_service.dart';
import 'package:circloop_movil/services/facultad_service.dart';
import 'package:circloop_movil/services/rol_service.dart';
import 'package:circloop_movil/services/usuario_service.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FacultadService _facultadService = FacultadService();
  final CarreraService _carreraService = CarreraService();
  final RolService _rolService = RolService();
  final UsuarioService _usuarioService = UsuarioService();

  String mensaje = 'Cargando datos...';

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final facultades = await _facultadService.obtenerFacultades();
    final carreras = await _carreraService.obtenerCarreras();
    final roles = await _rolService.obtenerRoles();
    final usuarios = await _usuarioService.obtenerUsuarios();

    setState(() {
      mensaje =
          '''
Facultades: ${facultades.length}
Carreras: ${carreras.length}
Roles: ${roles.length}
Usuarios: ${usuarios.length}
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(child: Text(mensaje)),
    );
  }
}
