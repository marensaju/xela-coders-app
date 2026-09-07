// ⚠️ VULNERABILIDAD INTENCIONAL #1: Secretos hardcodeados en el código fuente
//
// En vez de inyectar estas claves en tiempo de build (--dart-define) o
// recuperarlas de un backend de configuración remoto autenticado, esta app
// las declara como constantes en el propio código Dart. Al compilar en modo
// AOT (release), estas cadenas de texto quedan literalmente en el binario
// `libapp.so` y son extraíbles con `strings libapp.so | grep -i api` o con
// herramientas de reconstrucción de símbolos como Blutter.
//
// Además, se duplican en el asset .env (ver pubspec.yaml), lo que da DOS
// vectores independientes para exfiltrar las mismas credenciales.
//
// Todos los valores son FICTICIOS (organización Xela Coders, demo educativa).

class EnvConfig {
  // Duplicado intencionalmente como constante embebida en el binario,
  // además de vivir en el asset .env.
  static const String appId = 'xela-coders-demo-app-001';
  static const String apiKey = 'AIzaSyD_XELA_DEMO_FAKEKEY_1234567890ab';
  static const String apiBaseUrl = 'http://10.0.2.2:3000/api';

  static const String firebaseDatabaseUrl =
      'https://xelacoders-demo-default-rtdb.firebaseio.com';
  static const String firebaseApiKey =
      'AIzaSyD_XELA_FIREBASE_DEMO_FAKEKEY_abcdef';

  // Token de una colección de Postman embebido "por comodidad del equipo de
  // desarrollo" — mismo patrón hallado en el caso real que inspira esta demo.
  static const String postmanApiToken =
      'PMAK-xelacoders-demo-000000000000000000000000';
}
