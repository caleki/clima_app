class WeatherModel {
  final String cityName;
  final String conditionText;
  final double temperature;
  final String iconUrl;

  WeatherModel({
    required this.cityName,
    required this.conditionText,
    required this.temperature,
    required this.iconUrl,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'],
      conditionText: json['current']['condition']['text'],
      temperature: json['current']['temp_c'],
      iconUrl: "https:${json['current']['condition']['icon']}",
    );
  }
}
