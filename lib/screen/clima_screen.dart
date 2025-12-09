import 'package:caleki_climas/presentation/providers/preferences_provider.dart';
import 'package:caleki_climas/presentation/providers/weather_provider.dart';
import 'package:caleki_climas/presentation/widgets/weather_info_display.dart';
import 'package:caleki_climas/presentation/widgets/weather_video_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClimaScreen extends StatefulWidget {
  final String? ciudadInicial;

  const ClimaScreen({super.key, this.ciudadInicial});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Si hay ciudad inicial, buscamos el clima nada más cargar
    if (widget.ciudadInicial != null && widget.ciudadInicial!.isNotEmpty) {
      _controller.text = widget.ciudadInicial!;
      // Usamos addPostFrameCallback para asegurar que el contexto y provider estén listos
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _buscarClima();
      });
    }
  }

  void _buscarClima() {
    final ciudad = _controller.text.trim();
    if (ciudad.isNotEmpty) {
      // 1. Obtener clima
      context.read<WeatherProvider>().fetchWeather(ciudad);
      // 2. Agregar a historial (separación de preocupaciones a través de providers)
      context.read<UserPreferencesProvider>().agregarAHistorial(ciudad);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios en el proveedor de clima
    final weatherState = context.watch<WeatherProvider>();

    return Stack(
      children: [
        // Fondo con video dinámico
        WeatherVideoBackground(weather: weatherState.weather),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'EL CLIMA HOY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Barra de búsqueda
                  _buildSearchBar(context),

                  const SizedBox(height: 20),

                  // Estados de la UI: Loading, Error, Content
                  if (weatherState.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (weatherState.errorMessage != null)
                    _buildError(weatherState.errorMessage!)
                  else if (weatherState.weather != null)
                    WeatherInfoDisplay(weather: weatherState.weather!),
                ],
              ),
            ),
          ),
          // Botón flotante para favoritos
          floatingActionButton:
              weatherState.weather != null
                  ? FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      context.read<UserPreferencesProvider>().agregarAFavoritos(
                        weatherState.weather!.ciudad,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${weatherState.weather!.ciudad} agregada a favoritos',
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                  )
                  : null,
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onSubmitted: (_) => _buscarClima(),
        decoration: InputDecoration(
          hintText: 'Buscar ciudad...',
          prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: _buscarClima,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildError(String msg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.redAccent),
          const SizedBox(height: 10),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
