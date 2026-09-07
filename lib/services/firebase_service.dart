import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';

/// Servicio de Firebase Realtime Database de Xela Coders App.
///
/// ⚠️ VULNERABILIDAD INTENCIONAL #2: Backend (Firebase) mal configurado.
///
/// Esta demo NO usa el SDK `firebase_database` con reglas de seguridad
/// reales (para eso se necesitaría un proyecto Firebase real), pero
/// reproduce el patrón exacto de explotación mediante llamadas REST planas,
/// que es como se puede verificar la exposición en la vida real:
///
///   GET https://<proyecto>.firebaseio.com/<nodo>.json
///
/// Ver `backend/firebase-rules-demo.json`, que documenta unas reglas del
/// estilo:
///   { "rules": { ".read": true, ".write": true } }
///
/// es decir, lectura y escritura públicas sin exigir autenticación
/// (`auth != null`). Combinado con una Google API Key sin restricciones de
/// aplicación/API (con Identity Toolkit habilitado), esto permite:
///   1. Leer/escribir datos de cualquier usuario sin autenticarse.
///   2. Usar la API Key expuesta para invocar directamente la Identity
///      Toolkit API (signUp, signInWithPassword, etc.) fuera del contexto
///      de la app.
///
/// La corrección real es: reglas de Firebase que exijan `auth != null` y
/// validen `auth.uid` contra el propietario del recurso, además de
/// restringir la API Key por aplicación (SHA-1/paquete) y por API
/// habilitada en Google Cloud Console.
class FirebaseService {
  /// Simula una lectura NO autenticada al nodo de usuarios.
  /// En el caso real esto se probó con `curl` sin ningún header de
  /// autorización y devolvía datos completos.
  Future<Map<String, dynamic>> readUnauthenticated(String node) async {
    final uri = Uri.parse('${EnvConfig.firebaseDatabaseUrl}/$node.json');
    // Nótese: NO se envía ningún ID token de Firebase Auth.
    final response = await http.get(uri);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Simula una escritura NO autenticada (prueba de concepto de PoC,
  /// nunca ejecutar contra un proyecto real sin coordinación).
  Future<void> writeUnauthenticated(
      String node, Map<String, dynamic> data) async {
    final uri = Uri.parse('${EnvConfig.firebaseDatabaseUrl}/$node.json');
    await http.put(uri, body: jsonEncode(data));
  }
}
