import '../entities/weather.dart';

abstract class WeatherRepository {
  /// Obtiene los datos del clima para una [ciudad] específica.
  /// Retorna un objeto [Weather] si tiene éxito, o null (o lanza excepción) si falla.
  Future<Weather?> getWeather(String ciudad);
}
