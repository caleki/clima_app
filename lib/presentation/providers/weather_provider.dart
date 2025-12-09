import 'package:flutter/material.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository weatherRepository;

  WeatherProvider({required this.weatherRepository});

  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String ciudad) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await weatherRepository.getWeather(ciudad);
      if (result != null) {
        _weather = result;
      } else {
        _errorMessage = "No se pudo encontrar el clima para $ciudad";
      }
    } catch (e) {
      _errorMessage = "Error al obtener clima: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
