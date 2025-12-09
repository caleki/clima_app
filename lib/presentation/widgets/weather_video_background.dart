import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/weather.dart';

class WeatherVideoBackground extends StatefulWidget {
  final Weather? weather;

  const WeatherVideoBackground({super.key, this.weather});

  @override
  State<WeatherVideoBackground> createState() => _WeatherVideoBackgroundState();
}

class _WeatherVideoBackgroundState extends State<WeatherVideoBackground> {
  late VideoPlayerController _controller;
  String _currentVideoPath = 'assets/videos/despejado.mp4'; // Default

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(WeatherVideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Aquí podríamos detectar cambio de clima y cambiar el video
    // Por simplicidad y para asegurar funcionalidad básica, mantenemos el default o
    // implementamos la lógica de utils si es necesario.
    // Si quisieramos usar la lógica del helper:
    // final newVideo = getVideo... (widget.weather...);
    // if (newVideo != _currentVideoPath) { ... }
  }

  void _initializeController() {
    _controller =
        VideoPlayerController.asset(
            _currentVideoPath,
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          )
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            // Aseguramos que el widget siga montado antes de hacer setState
            if (mounted) {
              setState(() {});
              _controller.play();
            }
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(color: Colors.blueAccent); // Placeholder
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
