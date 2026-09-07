import 'package:flutter/material.dart';
import 'consulta_screen.dart';

/// Home de la app. Nótese (ver PROGRESS.md, fuera de alcance v1) que no
/// existe ninguna opción de "Cerrar sesión" en esta pantalla ni en ninguna
/// otra: la sesión guardada en SharedPreferences vive indefinidamente.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xela Coders App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ConsultaScreen()),
            );
          },
          child: const Text('Consultar registro'),
        ),
      ),
    );
  }
}
