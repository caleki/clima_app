String getVideoForConditionAndTime({
  required String condition,
  required DateTime horaCiudad,
  required DateTime amanecer,
  required DateTime atardecer,
}) {
  final cond = condition.toLowerCase();

  // Determinar momento del día en base a hora, amanecer y atardecer
  String momento;
  if (horaCiudad.isBefore(amanecer) || horaCiudad.isAfter(atardecer)) {
    momento = 'noche';
  } else if (horaCiudad.isBefore(amanecer.add(const Duration(hours: 2)))) {
    momento = 'amanecer';
  } else if (horaCiudad.isBefore(atardecer.subtract(const Duration(hours: 2)))) {
    momento = 'dia';
  } else {
    momento = 'atardecer';
  }

  // Determinar clima
  if (cond.contains('soleado') || cond.contains('despejado')) {
    return 'assets/videos/${momento}_despejado.mp4';
  } else if (cond.contains('nublado')) {
    return 'assets/videos/${momento}_inicio.mp4';
  } else if (cond.contains('lluvia') || cond.contains('llovizna')) {
    return 'assets/videos/${momento}_inicio.mp4';
  } else {
    return 'assets/videos/${momento}_inicio.mp4';
  }
}
