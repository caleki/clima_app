import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRemoteDataSource {
  // En un caso real, esto debería venir de variables de entorno (env).
  static const _apiKey = '591ddf51ffa74d138d8115438251907';
  static const _baseUrl = 'http://api.weatherapi.com/v1';

  /// Llama a la API de clima y devuelve un [WeatherModel] o lanza excepción.
  Future<WeatherModel?> getWeather(String ciudad) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast.json?key=$_apiKey&q=$ciudad&days=1&lang=es',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        // Podríamos manejar errores específicos aquí
        // print('Error API: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      // print('Error networking: $e');
      rethrow;
    }
  }
}
