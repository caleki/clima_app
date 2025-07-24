import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../utils/constants.dart';

class WeatherService {
  Future<WeatherModel> fetchWeather(String city) async {
    final url = Uri.parse('$weatherBaseUrl/current.json?key=$weatherApiKey&q=$city&lang=es');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return WeatherModel.fromJson(jsonData);
    } else {
      throw Exception('Error al cargar el clima');
    }
  }
}
