import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../utils/app_strings.dart';
import '../../widgets/comunidad/boton_codigo_qr.dart';
import '../../widgets/comunidad/resumen_perfil_comunidad.dart';
import '../../widgets/navegacion/barra_superior.dart';
import '../../widgets/navegacion/panel_navegacion.dart';
import '../comunes/en_construccion_screen.dart';
import '../comunes/perfil_screen.dart';
import 'canjes_comunidad_screen.dart';
import 'inicio_comunidad_screen.dart';
import 'reciclaje_comunidad_screen.dart';

/// Pestañas del rol comunidad. El orden importa: los botones de acción
/// del inicio cambian de pestaña por índice.
class PestanaComunidad {
  static const int inicio = 0;
  static const int reciclaje = 1;
  static const int canjes = 2;
  static const int experiencia = 3;
  static const int perfil = 4;
}

/// Panel principal del rol comunidad (estudiantes y comunidad universitaria).
class PanelComunidadScreen extends ConsumerWidget {
  const PanelComunidadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authProvider).value;

    // Mientras se cierra la sesión el usuario ya es null
    if (usuario == null) return const Scaffold();

    return PanelNavegacion(
      barraSuperior: BarraSuperior(
        usuario: usuario,
        puntos: usuario.puntosTotales,
        pestanaPerfil: PestanaComunidad.perfil,
      ),
      secciones: const [
        SeccionPanel(
          etiqueta: AppStrings.navInicio,
          icono: Icons.home_outlined,
          iconoActivo: Icons.home_rounded,
          pantalla: InicioComunidadScreen(),
        ),
        // TODO: reemplazar por las pantallas reales de cada pestaña.
        SeccionPanel(
          etiqueta: AppStrings.navReciclaje,
          icono: Icons.delete_outline,
          iconoActivo: Icons.delete,
          pantalla: ReciclajeComunidadScreen(),
          botonFlotante: BotonCodigoQr(),
        ),
        SeccionPanel(
          etiqueta: AppStrings.navCanjes,
          icono: Icons.card_giftcard_outlined,
          iconoActivo: Icons.card_giftcard,
          pantalla: CanjesComunidadScreen(),
        ),
        SeccionPanel(
          etiqueta: AppStrings.navExperiencia,
          icono: Icons.emoji_events_outlined,
          iconoActivo: Icons.emoji_events,
          pantalla: EnConstruccionScreen(
            titulo: AppStrings.navExperiencia,
            icono: Icons.emoji_events_outlined,
          ),
        ),
        SeccionPanel(
          etiqueta: AppStrings.navPerfil,
          icono: Icons.person_outline,
          iconoActivo: Icons.person,
          pantalla: PerfilScreen(contenidoRol: ResumenPerfilComunidad()),
        ),
      ],
    );
  }
}
