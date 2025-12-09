import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Weather?> getWeather(String ciudad) async {
    try {
      return await remoteDataSource.getWeather(ciudad);
    } catch (e) {
      // Aquí se podrían manejar excepciones de red y retornar Failures del dominio
      return null;
    }
  }
}
