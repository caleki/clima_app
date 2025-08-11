import 'package:flutter/material.dart';

class HistorialScreen extends StatelessWidget {
  final List<String> historial;
  const HistorialScreen({super.key, required this.historial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial")),
      body: historial.isEmpty
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
