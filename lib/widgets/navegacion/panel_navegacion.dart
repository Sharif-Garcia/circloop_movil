import 'package:flutter/material.dart';

/// Una pestaña del panel: ícono, etiqueta, la pantalla que muestra y,
/// opcionalmente, un botón flotante que solo aparece en esa pestaña.
class SeccionPanel {
  final String etiqueta;
  final IconData icono;
  final IconData iconoActivo;
  final Widget pantalla;
  final Widget? botonFlotante;

  const SeccionPanel({
    required this.etiqueta,
    required this.icono,
    required this.iconoActivo,
    required this.pantalla,
    this.botonFlotante,
  });
}

/// Estructura base del panel de cualquier rol: barra superior, contenido y
/// navegación inferior por pestañas. Cada rol solo define sus [secciones].
///
/// Las pestañas conservan su estado al cambiar entre ellas. Desde cualquier
/// widget dentro del panel se puede cambiar de pestaña con
/// `PanelNavegacion.of(context).irA(indice)`.
class PanelNavegacion extends StatefulWidget {
  final List<SeccionPanel> secciones;
  final PreferredSizeWidget? barraSuperior;

  const PanelNavegacion({
    super.key,
    required this.secciones,
    this.barraSuperior,
  });

  static PanelNavegacionState of(BuildContext context) {
    final estado = context.findAncestorStateOfType<PanelNavegacionState>();
    assert(estado != null, 'No hay un PanelNavegacion encima de este widget.');
    return estado!;
  }

  @override
  State<PanelNavegacion> createState() => PanelNavegacionState();
}

class PanelNavegacionState extends State<PanelNavegacion> {
  int _indice = 0;

  void irA(int indice) => setState(() => _indice = indice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.barraSuperior,
      floatingActionButton: widget.secciones[_indice].botonFlotante,
      body: IndexedStack(
        index: _indice,
        children: [for (final seccion in widget.secciones) seccion.pantalla],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: irA,
        destinations: [
          for (final seccion in widget.secciones)
            NavigationDestination(
              icon: Icon(seccion.icono),
              selectedIcon: Icon(seccion.iconoActivo),
              label: seccion.etiqueta,
            ),
        ],
      ),
    );
  }
}
