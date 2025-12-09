import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.ciudad,
    required super.temperature,
    required super.maxTemp,
    required super.minTemp,
    required super.condition,
    required super.descripcion,
    required super.iconUrl,
    required super.fechaHora,
    required super.sunrise,
    required super.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      ciudad: json['location']['name'],
      // temperature: json['current']['temp_c'].toDouble(), // Guardamos como double
      temperature: (json['current']['temp_c'] as num).toDouble(),
      descripcion: json['current']['condition']['text'],
      iconUrl: 'https:${json['current']['condition']['icon']}',
      maxTemp:
          (json['forecast']['forecastday'][0]['day']['maxtemp_c'] as num)
              .toDouble(),
      minTemp:
          (json['forecast']['forecastday'][0]['day']['mintemp_c'] as num)
              .toDouble(),
      condition: json['current']['condition']['text'],
      fechaHora: json['location']['localtime'],
      sunrise: json['forecast']['forecastday'][0]['astro']['sunrise'],
      sunset: json['forecast']['forecastday'][0]['astro']['sunset'],
    );
  }
}
