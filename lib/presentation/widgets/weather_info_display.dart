import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/weather.dart';
import 'package:intl/intl.dart';

class WeatherInfoDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherInfoDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    String fechaFormateada = '';
    // Intenta parsear la fecha, manejando posibles errores
    try {
      final dateTime = DateTime.tryParse(weather.fechaHora);
      if (dateTime != null) {
        // Usamos formato genérico si no hay locale 'es' inicializado globalmente,
        // o asumimos que main.dart lo inicializó.
        final formato = DateFormat('EEEE d MMMM yyyy, HH:mm', 'es');
        fechaFormateada = formato.format(dateTime);
      }
    } catch (_) {
      fechaFormateada = weather.fechaHora;
    }

    return Column(
      children: [
        Text(
          weather.ciudad,
          style: GoogleFonts.poppins(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          fechaFormateada,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 20),
        if (weather.iconUrl.isNotEmpty)
          SizedBox(
            height: 100,
            width: 100,
            child: Image.network(
              weather.iconUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.cloud, size: 64, color: Colors.grey);
              },
            ),
          ),
        Text(
          '${weather.temperature}°C', // Usamos el double formateado
          style: GoogleFonts.poppins(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTempBox('${weather.maxTemp}°C', 'MAXIMA', Colors.redAccent),
            const SizedBox(width: 20),
            _buildTempBox('${weather.minTemp}°C', 'MINIMA', Colors.blueAccent),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            weather.descripcion,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTempBox(String temp, String label, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 140, // Ancho fijo para consistencia
        child: Column(
          children: [
            Text(
              temp,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
