import 'package:flutter/material.dart';
import 'clima_screen.dart'; // tu pantalla de clima
import '../services/fav_services.dart'; // tu servicio de favoritos

class FavoritosScreen extends StatefulWidget {
    final List<String> favoritos;

  const FavoritosScreen({Key? key, required this.favoritos}) : super(key: key);

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  List<String> favoritos = []; // lista de ciudades favoritas
  bool loading = true; // para mostrar un indicador de carga

  @override
  void initState() {
    super.initState();
    _load(); // al iniciar la pantalla, cargamos los favoritos
  }

  // Carga los favoritos desde SharedPreferences (sistema local)
  Future<void> _load() async {
    setState(() => loading = true); // muestra loading
    favoritos = await FavoritosService.loadFavoritos(); // carga lista
    setState(() => loading = false); // oculta loading
  }

  // Elimina un favorito de la lista y vuelve a cargar
  Future<void> _remove(String ciudad) async {
    await FavoritosService.removeFavorito(ciudad);
    await _load(); // recarga la lista actualizada
  }

  @override
  Widget build(BuildContext context) {
    // Si está cargando, muestra un spinner
    if (loading) return const Center(child: CircularProgressIndicator());

    // Si no hay favoritos guardados
    if (favoritos.isEmpty) {
      return const Center(child: Text('No hay favoritos aún.'));
    }

    // Si hay favoritos, los mostramos en una lista
    return ListView.separated(
      itemCount: favoritos.length,
      separatorBuilder: (_, __) => const Divider(), // línea divisoria
      itemBuilder: (context, index) {
        final ciudad = favoritos[index]; // ciudad actual
        return ListTile(
          title: Text(ciudad), // nombre de la ciudad
          trailing: IconButton(
            icon: const Icon(Icons.delete), // ícono de borrar
            onPressed: () => _remove(ciudad), // borra la ciudad de favoritos
          ),
          onTap: () {
            // Si el usuario toca la ciudad, abre ClimaScreen con esa ciudad
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ClimaScreen(
                    ciudadInicial: ciudad,                 // le pasamos la ciudad
                    onAgregarHistorial: (c) {},            // funciones vacías o reales
                    onCiudadBuscada: (c) {},               // según cómo manejes tu lógica
                    onAgregarFavorito: (c) async {         // guardar favorito
                      await FavoritosService.addFavorito(c);
                    },
              ),
            ),
            );
          },
        );
      },
    );
  }
}
