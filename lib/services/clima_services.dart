import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clima_model.dart';

class ClimaService {
  static const _apiKey = '591ddf51ffa74d138d8115438251907';
  static const _baseUrl = 'http://api.weatherapi.com/v1';

  static Future<ClimaModel?> obtenerClima(String ciudad) async {
    try {
    final url = Uri.parse('$_baseUrl/forecast.json?key=$_apiKey&q=$ciudad&days=1&lang=es');
    final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ClimaModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener clima: $e');
      return null;
    }
  }
}
