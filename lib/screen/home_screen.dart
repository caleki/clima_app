import 'package:caleki_climas/screen/fav_screen.dart';
import 'package:caleki_climas/screen/historial_screen.dart';
import 'package:flutter/material.dart';
import 'clima_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaActual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _paginas = [
      const ClimaScreen(),
      const FavoritosScreen(),
      const HistorialScreen(),
    ];

    return Scaffold(
      body: _paginas[_paginaActual],
      bottomNavigationBar: NavigationBar(
        // Material 3 uses NavigationBar
        selectedIndex: _paginaActual,
        onDestinationSelected: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cloud_outlined),
            selectedIcon: Icon(Icons.cloud),
            label: "Clima",
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: "Favoritos",
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: "Historial",
          ),
        ],
      ),
    );
  }
}
