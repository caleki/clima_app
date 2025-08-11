import 'package:caleki_climas/screen/fav_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'clima_screen.dart';
import 'historial_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaActual = 0;
  List<String> favoritos = [];
  List<String> historial = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritos = prefs.getStringList('favoritos') ?? [];
      historial = prefs.getStringList('historial') ?? [];
    });
  }

  Future<void> _guardarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoritos', favoritos);
  }

  Future<void> _guardarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('historial', historial);
  }

  void agregarAFavoritos(String ciudad) {
    if (!favoritos.contains(ciudad)) {
      setState(() {
        favoritos.add(ciudad);
      });
      _guardarFavoritos();
    }
  }

  void agregarAHistorial(String ciudad) {
    setState(() {
      historial.insert(0, ciudad);
    });
    _guardarHistorial();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _paginas = [
      ClimaScreen(
        onAgregarHistorial: agregarAHistorial,
        onCiudadBuscada: agregarAHistorial,
        onAgregarFavorito: agregarAFavoritos,
      ),
      FavoritosScreen(favoritos: favoritos),
      HistorialScreen(historial: historial),
    ];

    return Scaffold(
      body: _paginas[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: "Clima",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favoritos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historial",
          ),
        ],
      ),
    );
  }
}
