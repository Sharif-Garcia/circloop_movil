import 'package:flutter/material.dart';

import '../../models/onboarding_paso.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

// Contenido de los pasos del onboarding. Para agregar o cambiar un paso,
// solo se edita esta lista; la pantalla se adapta sola.
const List<OnboardingPaso> pasosOnboarding = [
  OnboardingPaso(
    titulo: 'Recicla en tu campus',
    descripcion:
        'Encuentra las estaciones de reciclaje inteligentes distribuidas en la universidad.',
    etiqueta: 'Identificación del campus',
    imagen: AppImages.onboardingReciclaje,
    icono: Icons.recycling,
    color: AppColors.primary,
    iconosSecundarios: [Icons.location_on, Icons.local_drink],
  ),
  OnboardingPaso(
    titulo: 'Gana puntos y premios',
    descripcion:
        'Acumula puntos por cada entrega de material reciclable y cámbialos por incentivos.',
    etiqueta: 'Recompensas sostenibles',
    imagen: AppImages.onboardingPuntos,
    icono: Icons.card_giftcard,
    color: AppColors.tertiary,
    iconosSecundarios: [Icons.stars, Icons.local_cafe],
  ),
  OnboardingPaso(
    titulo: 'Transforma tu universidad',
    descripcion:
        'Sé parte del cambio en la Universidad Popular del Cesar impulsando la economía circular.',
    etiqueta: 'Impacto ambiental',
    imagen: AppImages.onboardingTransforma,
    icono: Icons.school,
    color: AppColors.secondary,
    iconosSecundarios: [Icons.eco, Icons.groups],
  ),
];
