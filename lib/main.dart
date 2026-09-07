import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

/// Punto de entrada de Xela Coders App (demo vulnerable educativa).
///
/// Nota (ver PROGRESS.md, fuera de alcance v1): no hay ninguna comprobación
/// de entorno comprometido aquí (root/jailbreak detection, detección de
/// depurador o de Frida attach). La app arranca igual en cualquier
/// dispositivo o emulador.
void main() {
  runApp(const XelaCodersApp());
}

class XelaCodersApp extends StatelessWidget {
  const XelaCodersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xela Coders App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const LoginScreen(),
    );
  }
}
