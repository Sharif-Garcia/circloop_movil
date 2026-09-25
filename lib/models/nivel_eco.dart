/// Nivel de gamificación según los puntos históricos (XP) del usuario.
class NivelEco {
  final int numero;
  final String nombre;

  /// XP necesaria para llegar a este nivel.
  final int xpMinima;

  const NivelEco({
    required this.numero,
    required this.nombre,
    required this.xpMinima,
  });

  static const List<NivelEco> niveles = [
    NivelEco(numero: 1, nombre: 'Eco Semilla', xpMinima: 0),
    NivelEco(numero: 2, nombre: 'Eco Explorador', xpMinima: 500),
    NivelEco(numero: 3, nombre: 'Eco Warrior', xpMinima: 1000),
    NivelEco(numero: 4, nombre: 'Eco Guardián', xpMinima: 2000),
    NivelEco(numero: 5, nombre: 'Eco Leyenda', xpMinima: 3500),
  ];

  /// Nivel que corresponde a [xp].
  static NivelEco paraXp(int xp) {
    return niveles.lastWhere((nivel) => xp >= nivel.xpMinima);
  }

  /// Nivel siguiente, o `null` si este es el máximo.
  NivelEco? get siguiente {
    final indice = niveles.indexOf(this);
    return indice < niveles.length - 1 ? niveles[indice + 1] : null;
  }

  /// Avance dentro de este nivel, de 0.0 a 1.0.
  double progreso(int xp) {
    final meta = siguiente;
    if (meta == null) return 1.0;
    return ((xp - xpMinima) / (meta.xpMinima - xpMinima)).clamp(0.0, 1.0);
  }
}
