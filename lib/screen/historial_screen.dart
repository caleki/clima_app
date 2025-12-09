import 'package:caleki_climas/presentation/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumimos el historial del provider
    final historial = context.watch<UserPreferencesProvider>().historial;

    return Scaffold(
      appBar: AppBar(title: const Text("Historial")),
      body:
          historial.isEmpty
              ? const Center(child: Text("No hay historial de búsquedas"))
              : ListView.builder(
                itemCount: historial.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(historial[index]),
                  );
                },
              ),
    );
  }
}
