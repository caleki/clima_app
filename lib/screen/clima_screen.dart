import 'package:caleki_climas/models/clima_model.dart';
import 'package:caleki_climas/services/clima_services.dart';
import 'package:caleki_climas/utils/weather_background.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:video_player/video_player.dart';

class ClimaScreen extends StatefulWidget {
  final String? ciudadInicial; // ciudad inicial opcional
  final Function(String) onAgregarHistorial;
  final Function(String) onCiudadBuscada;
  final Function(String) onAgregarFavorito;

  const ClimaScreen({
    super.key,
    this.ciudadInicial,
    required this.onAgregarHistorial,
    required this.onCiudadBuscada,
    required this.onAgregarFavorito,
  });

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  final TextEditingController _controller = TextEditingController();
  ClimaModel? clima;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset(
            'assets/videos/cielo_soleado.mp4',
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          )
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
          });

    // 🔹 Si viene una ciudad desde Favoritos, la buscamos automáticamente
    if (widget.ciudadInicial != null && widget.ciudadInicial!.isNotEmpty) {
      _controller.text = widget.ciudadInicial!; // rellena el buscador
      _buscarClima(); // dispara la búsqueda sin que el usuario escriba
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _buscarClima() async {
    final resultado = await ClimaService.obtenerClima(_controller.text);

    setState(() {
      clima = resultado;
      initializeDateFormatting('es');
    });

    if (clima != null) {
      widget.onAgregarHistorial(clima!.ciudad); //Agrega al historial
    }
  }

  @override
  Widget build(BuildContext context) {
    // Formatear la fecha actual
    String fechaFormateada = '';

    if (clima != null && clima!.fechaHora.isNotEmpty) {
      final dateTime = DateTime.tryParse(clima!.fechaHora);
      if (dateTime != null) {
        final formato = DateFormat('EEEE d MMMM yyyy, HH:mm', 'es');
        fechaFormateada = formato.format(dateTime);
      }
    }

    return Stack(
      children: [
        // Video de fondo si no hay clima cargado
        if (clima == null && _videoController.value.isInitialized)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          ),
        // Fondo dinámico según el clima
        if (clima != null)
          Image(
            image: getBackgroundForCondition(clima!.condition),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        // Scaffold transparente para mostrar contenido encima del fondo
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(130),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'EL CLIMA HOY \n EN LA CIUDAD',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        height: 1.1,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  // 🔹 El buscador: ahora puede venir prellenado desde Favoritos
                  TextField(
                    controller: _controller,
                    onSubmitted: (_) => _buscarClima(),
                    decoration: const InputDecoration(
                      labelText: '',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _buscarClima,
                    child: const Text('Buscar'),
                  ),
                  const SizedBox(height: 30),
                  // 🔹 Si hay clima, mostrar datos
                  if (clima != null) ...[
                    Text(clima!.ciudad, style: const TextStyle(fontSize: 34)),

                    Text(
                      fechaFormateada,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),

                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(clima!.iconUrl, fit: BoxFit.cover),
                    ),
                    Text(
                      clima!.temperatura,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 25,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                              ), // Estilo base
                              children: [
                                TextSpan(
                                  text: '  ${clima!.maxTemp}°C\n',
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'MAXIMA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 70),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 25,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                              ), // Estilo base
                              children: [
                                TextSpan(
                                  text: '  ${clima!.minTemp}°C\n',
                                  style: const TextStyle(
                                    fontSize:
                                        34, // Tamaño grande para el número
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'MINIMA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        14, // Tamaño más chico para el texto
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      clima!.descripcion,
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
          // Botón flotante para agregar a favoritos
          floatingActionButton:
              clima != null
                  ? FloatingActionButton(
                    backgroundColor: Colors.white,
                    tooltip: 'Agregar a Favoritos',
                    onPressed: () {
                      widget.onAgregarFavorito(clima!.ciudad);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ciudad agregada a favoritos'),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 255, 196, 0),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
