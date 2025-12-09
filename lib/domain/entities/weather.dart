class Weather {
  final String ciudad;
  final double temperature;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String descripcion;
  final String iconUrl;
  final String fechaHora;
  final String sunrise;
  final String sunset;

  const Weather({
    required this.ciudad,
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.descripcion,
    required this.iconUrl,
    required this.fechaHora,
    required this.sunrise,
    required this.sunset,
  });
}
