import 'package:caleki_climas/presentation/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'clima_screen.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumimos el estado directamente del provider para que se actualice al borrar
    final userPrefs = context.watch<UserPreferencesProvider>();
    final favoritos = userPrefs.favoritos;

    if (favoritos.isEmpty) {
      return const Center(child: Text('No hay favoritos aún.'));
    }

    return ListView.separated(
      itemCount: favoritos.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final ciudad = favoritos[index];
        return ListTile(
          title: Text(ciudad),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            // Eliminamos usando el provider (necesitaríamos implementar remove en el provider si no existe)
            // Revisando provider... no implementé remove :(
            // Espera, implementar removeFavorito en UserPreferencesProvider primero?
            // Dejaré el TODO o implementaré un método simple si puedo editar el provider rápido.
            // Asumiré que el usuario quiere que funcione, así que editaré el provider primero o aquí.
            // Como no puedo editar 2 archivos en 1 tool, y no tengo remove,
            // usaré una lógica temporal o mejor: edito el provider luego.
            // Ah, el usuario no pidió explícitamente borrar, pero la pantalla lo tenía.
            // Voy a ocultar el botón de borrar por ahora O dejarlo sin acción o llamar a una funcion que añadiré.
            // Mejor: Implementar remove en provider es rápido.
            onPressed: () {
              context.read<UserPreferencesProvider>().eliminarFavorito(ciudad);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$ciudad eliminada de favoritos")),
              );
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ClimaScreen(ciudadInicial: ciudad),
              ),
            );
          },
        );
      },
    );
  }
}
