import '../../models/onboarding_paso.dart';
import '../../utils/app_images.dart';

// Contenido de los pasos del onboarding. Para agregar o cambiar un paso,
// solo se edita esta lista; la pantalla se adapta sola.
const List<OnboardingPaso> pasosOnboarding = [
  OnboardingPaso(
    titulo: 'Recicla en tu campus',
    descripcion:
        'Encuentra las estaciones de reciclaje inteligentes distribuidas en la universidad.',
    pie: 'Paso 1 de 3: Identificación del campus',
    imagen: AppImages.mascota,
  ),
  OnboardingPaso(
    titulo: 'Gana puntos y premios',
    descripcion:
        'Acumula puntos por cada entrega de material reciclable y cámbialos por incentivos.',
    pie: 'Paso 2 de 3: Recompensas sostenibles',
    imagen: AppImages.mascota,
  ),
  OnboardingPaso(
    titulo: 'Transforma tu universidad',
    descripcion:
        'Sé parte del cambio en la Universidad Popular del Cesar impulsando la economía circular.',
    pie: 'Paso 3 de 3: Impacto ambiental',
    imagen: AppImages.mascota,
  ),
];
