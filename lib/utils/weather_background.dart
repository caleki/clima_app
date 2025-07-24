import 'package:flutter/material.dart';

AssetImage getBackgroundForCondition(String condition) {
  final cond = condition.toLowerCase();
  if (cond.contains('soleado') || cond.contains('despejado')) {
    return const AssetImage('assets/soleado.jpg');
  } else if (cond.contains('nublado')) {
    return const AssetImage('assets/nublado.jpg');
  } else if (cond.contains('lluvia') || cond.contains('llovizna')) {
    return const AssetImage('assets/lluvia.jpeg');
  } else if (cond.contains('noche')) {
    return const AssetImage('assets/noche.jpg');
  } else {
    return const AssetImage('assets/defecto.jpg'); // Fondo por defecto
  } 
}