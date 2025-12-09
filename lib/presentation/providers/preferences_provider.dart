import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesProvider extends ChangeNotifier {
  List<String> _favoritos = [];
  List<String> _historial = [];

  List<String> get favoritos => _favoritos;
  List<String> get historial => _historial;

  UserPreferencesProvider() {
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    _favoritos = prefs.getStringList('favoritos') ?? [];
    _historial = prefs.getStringList('historial') ?? [];
    notifyListeners();
  }

  Future<void> agregarAFavoritos(String ciudad) async {
    if (!_favoritos.contains(ciudad)) {
      _favoritos.add(ciudad);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favoritos', _favoritos);
    }
  }

  Future<void> agregarAHistorial(String ciudad) async {
    // Evitar duplicados consecutivos o mover al inicio si ya existe
    if (_historial.contains(ciudad)) {
      _historial.remove(ciudad);
    }
    _historial.insert(0, ciudad);
    // Limitar historial a 10 items por ejemplo
    if (_historial.length > 10) {
      _historial.removeLast();
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('historial', _historial);
  }

  Future<void> eliminarFavorito(String ciudad) async {
    _favoritos.remove(ciudad);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoritos', _favoritos);
  }
}
