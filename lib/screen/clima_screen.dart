import 'package:caleki_climas/models/clima_model.dart';
import 'package:caleki_climas/services/clima_services.dart';
import 'package:caleki_climas/utils/weather_background.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:video_player/video_player.dart';

class ClimaScreen extends StatefulWidget {
  final String? ciudadInicial; 
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
  String? _videoPathActual;

  @override
  void initState() {
    super.initState();
    _videoPathActual = 'assets/videos/despejado.mp4';
    _videoController = VideoPlayerController.asset(
      _videoPathActual!,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });

    if (widget.ciudadInicial != null && widget.ciudadInicial!.isNotEmpty) {
      _controller.text = widget.ciudadInicial!;
      _buscarClima();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }


Future<void> _cambiarVideo(String nuevoPath) async {
  if (_videoPathActual == nuevoPath) return; // No cambies si es el mismo video

  final viejoController = _videoController;
  late VideoPlayerController nuevoController;

  try {
    nuevoController = VideoPlayerController.asset(
      nuevoPath,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )
      ..setLooping(true)
      ..setVolume(0);

    await nuevoController.initialize();
    await nuevoController.play();

    setState(() {
      _videoController = nuevoController;
      _videoPathActual = nuevoPath;
    });

    await viejoController.dispose();
  } catch (e) {
    // Si falla, muestra un mensaje y no cambia el video
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo cargar el video de fondo')),
    );
  }
}

  Future<void> _buscarClima() async {
    final resultado = await ClimaService.obtenerClima(_controller.text);

    if (resultado != null) {
      clima = resultado;

      // Parseo de horas
      final horaCiudad = DateTime.parse(clima!.fechaHora);
      final amanecer = DateFormat("yyyy-MM-dd h:mm a", "en_US").parse(
        "${horaCiudad.toIso8601String().split('T')[0]} ${clima!.sunrise}"
      );
      final atardecer = DateFormat("yyyy-MM-dd h:mm a", "en_US").parse(
        "${horaCiudad.toIso8601String().split('T')[0]} ${clima!.sunset}"
      );

      // Obtener ruta del video según clima + hora
      final videoPath = getVideoForConditionAndTime(
        condition: clima!.condition,
        horaCiudad: horaCiudad,
        amanecer: amanecer,
        atardecer: atardecer,
      );

      // Cambiar video dinámicamente solo si es necesario
      await _cambiarVideo(videoPath);

      initializeDateFormatting('es');
      widget.onAgregarHistorial(clima!.ciudad);

      setState(() {}); // Para refrescar los datos del clima
    }
  }

  @override
  Widget build(BuildContext context) {
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
        // Fondo con video dinámico
        if (_videoController.value.isInitialized)
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
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    onSubmitted: (_) => _buscarClima(),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  if (clima != null) ...[
                    Text(clima!.ciudad, style: const TextStyle(fontSize: 34)),
                    Text(
                      fechaFormateada,
                      style: const TextStyle(fontSize: 20, color: Colors.black54),
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
                        _buildTempBox('${clima!.maxTemp}°C', 'MAXIMA'),
                        const SizedBox(width: 70),
                        _buildTempBox('${clima!.minTemp}°C', 'MINIMA'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(clima!.descripcion, style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
          floatingActionButton: clima != null
              ? FloatingActionButton(
                  backgroundColor: Colors.white,
                  tooltip: 'Agregar a Favoritos',
                  onPressed: () {
                    widget.onAgregarFavorito(clima!.ciudad);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ciudad agregada a favoritos')),
                    );
                  },
                  child: const Icon(Icons.star, color: Color.fromARGB(255, 255, 196, 0)),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildTempBox(String temp, String label) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: '  $temp\n',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}