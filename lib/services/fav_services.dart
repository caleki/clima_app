import 'package:shared_preferences/shared_preferences.dart';

class FavoritosService {
  static const _key = 'favoritos';

  static Future<List<String>> loadFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? <String>[];
  }

  static Future<void> addFavorito(String ciudad) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? <String>[];
    if (!list.contains(ciudad)) {
      list.add(ciudad);
      await prefs.setStringList(_key, list);
    }
  }

  static Future<void> removeFavorito(String ciudad) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? <String>[];
    list.remove(ciudad);
    await prefs.setStringList(_key, list);
  }

  static Future<bool> isFavorito(String ciudad) async {
    final list = await loadFavoritos();
    return list.contains(ciudad);
  }
}
