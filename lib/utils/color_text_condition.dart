import 'package:flutter/material.dart';

Color getTextoColor(String condition) {
  final condicionesOscuras = ['nublado', 'lluvia', 'tormenta', 'noche'];
  if (condicionesOscuras.contains(condition.toLowerCase())) {
    return Colors.white;
  }
  return Colors.black;
}
