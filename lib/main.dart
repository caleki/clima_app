import 'package:caleki_climas/data/datasources/weather_remote_datasource.dart';
import 'package:caleki_climas/data/repositories/weather_repository_impl.dart';
import 'package:caleki_climas/presentation/providers/preferences_provider.dart';
import 'package:caleki_climas/presentation/providers/weather_provider.dart';
import 'package:caleki_climas/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inyección de Dependencias Manual (Service Locator simple)
  final weatherDataSource = WeatherRemoteDataSource();
  final weatherRepository = WeatherRepositoryImpl(
    remoteDataSource: weatherDataSource,
  );

  runApp(MyApp(weatherRepository: weatherRepository));
}

class MyApp extends StatelessWidget {
  final WeatherRepositoryImpl weatherRepository;

  const MyApp({super.key, required this.weatherRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(weatherRepository: weatherRepository),
        ),
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
      ],
      child: MaterialApp(
        title: 'Caleki Climas',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
