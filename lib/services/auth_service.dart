import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/env_config.dart';

/// Servicio de autenticación de Xela Coders App.
///
/// ⚠️ VULNERABILIDAD INTENCIONAL #5: Hash de contraseña con SHA1 sin salt.
/// SHA1 es un algoritmo de propósito general (rápido, diseñado para
/// integridad, no para almacenamiento de contraseñas) y sin salt es
/// trivialmente vulnerable a tablas rainbow y a ataques de fuerza bruta con
/// GPU. Lo correcto es un KDF lento con salt único por usuario: bcrypt,
/// scrypt o Argon2id.
///
/// ⚠️ VULNERABILIDAD INTENCIONAL #5b: "Pass-the-hash". El backend (ver
/// backend/server.js) acepta como credencial válida el HASH de la
/// contraseña en lugar de derivarlo y compararlo él mismo a partir de la
/// contraseña en texto plano enviada por TLS. Esto significa que un atacante
/// que intercepte o extraiga el hash (por ejemplo desde SharedPreferences, o
/// interceptando tráfico ya que tampoco hay certificate pinning, ver
/// api_service.dart) puede autenticarse SIN conocer la contraseña real.
///
/// ⚠️ VULNERABILIDAD INTENCIONAL #4: Ausencia total de MFA. El flujo de
/// login termina en éxito/fracaso con un solo factor (usuario+contraseña),
/// sin segundo factor (OTP, push, biometría con attestation server-side).
class AuthService {
  static const _sessionKey = 'xela_session_hash';

  /// Login con un solo factor. No hay paso de MFA en ningún punto del flujo.
  Future<bool> login(String username, String password) async {
    // SHA1 sin salt, calculado en el cliente.
    final passwordHash = sha1.convert(utf8.encode(password)).toString();

    final response = await http.post(
      Uri.parse('${EnvConfig.apiBaseUrl}/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': EnvConfig.apiKey, // vuln #1: API key hardcodeada viajando en cada request
      },
      body: jsonEncode({
        'username': username,
        // Se envía el HASH, no la contraseña. El backend lo compara
        // directamente contra lo almacenado -> pass-the-hash viable.
        'passwordHash': passwordHash,
      }),
    );

    if (response.statusCode == 200) {
      // ⚠️ La sesión se guarda indefinidamente, sin expiración, y sin que
      // exista una función de logout real en la UI (ver home_screen.dart).
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, passwordHash);
      return true;
    }
    return false;
  }

  Future<String?> getStoredSessionHash() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  // Nota para v2 (ver PROGRESS.md): no existe un método logout() que
  // invalide la sesión ni en cliente ni en servidor.
}
