class ClimaModel {
  final double temperature;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String ciudad;
  final String temperatura;
  final String descripcion;
  final String iconUrl;

  ClimaModel({
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.ciudad,
    required this.temperatura,
    required this.descripcion,
    required this.iconUrl,
  });

  factory ClimaModel.fromJson(Map<String, dynamic> json) {
    return ClimaModel(
      ciudad: json['location']['name'],
      temperatura: '${json['current']['temp_c']}°C',
      descripcion: json['current']['condition']['text'],
      iconUrl: 'https:${json['current']['condition']['icon']}',
      temperature: json['current']['temp_c'].toDouble(),
      maxTemp:
          json['forecast']['forecastday'][0]['day']['maxtemp_c'].toDouble(),
      minTemp:
          json['forecast']['forecastday'][0]['day']['mintemp_c'].toDouble(),
      condition: json['current']['condition']['text'],
    );
  }
}
