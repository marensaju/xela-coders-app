import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';

/// Cliente HTTP para los servicios backend de Xela Coders App.
///
/// ⚠️ VULNERABILIDAD INTENCIONAL #6: Sin certificate pinning.
/// Esta clase usa el cliente `http` estándar de Dart, que delega toda la
/// validación TLS al almacén de certificados de confianza del sistema
/// operativo (Android/iOS). Esto significa que si un atacante logra que el
/// dispositivo confíe en un certificado propio (por ejemplo instalando un
/// certificado raíz de un proxy interceptor tipo Burp Suite o mitmproxy —
/// trivial en un emulador o dispositivo rooteado/jailbreakeado, y a veces
/// posible incluso en dispositivos gestionados), todo el tráfico HTTPS de la
/// app puede interceptarse y modificarse en tránsito, sin que la app lo
/// detecte ni lo rechace.
///
/// La forma correcta es implementar pinning explícito (por ejemplo con
/// `HttpClient.badCertificateCallback` + comparación de huella SHA-256 del
/// certificado/clave pública esperado, o librerías como `http_certificate_pinning`),
/// y rechazar la conexión si el certificado presentado no coincide.
class ApiService {
  Future<Map<String, dynamic>> get(String path,
      {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('${EnvConfig.apiBaseUrl}$path')
        .replace(queryParameters: queryParams);

    // Petición HTTPS "normal": TLS se valida, pero contra CUALQUIER
    // certificado en el que confíe el sistema operativo. No hay pinning.
    final response = await http.get(
      uri,
      headers: {
        'x-api-key': EnvConfig.apiKey,
        'x-app-id': EnvConfig.appId,
      },
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
