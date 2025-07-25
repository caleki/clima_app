import 'package:caleki_climas/models/clima_model.dart';
import 'package:caleki_climas/services/clima_services.dart';
import 'package:caleki_climas/utils/weather_background.dart';
import 'package:flutter/material.dart';

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  final TextEditingController _controller = TextEditingController();
  ClimaModel? clima;

  Future<void> _buscarClima() async {
    final resultado = await ClimaService.obtenerClima(_controller.text);
    setState(() {
      clima = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo dinámico según el clima
        if (clima != null)
          Image(
            image: getBackgroundForCondition(clima!.condition),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        // Scaffold transparente para mostrar contenido encima del fondo
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(130),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'EL CLIMA HOY \n EN LA CIUDAD',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        height: 1.1,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    onSubmitted: (_) => _buscarClima(),
                    decoration: const InputDecoration(
                      labelText: '',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _buscarClima,
                    child: const Text('Buscar'),
                  ),
                  const SizedBox(height: 30),
                  if (clima != null) ...[
                    Text(clima!.ciudad, style: const TextStyle(fontSize: 34)),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(clima!.iconUrl, fit: BoxFit.cover),
                    ),
                    Text(
                      clima!.temperatura,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 25,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                              ), // Estilo base
                              children: [
                                TextSpan(
                                  text: '  ${clima!.maxTemp}°C\n',
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'MAXIMA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 70),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 25,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                              ), // Estilo base
                              children: [
                                TextSpan(
                                  text: '  ${clima!.minTemp}°C\n',
                                  style: const TextStyle(
                                    fontSize:
                                        34, // Tamaño grande para el número
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'MINIMA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        14, // Tamaño más chico para el texto
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      clima!.descripcion,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
