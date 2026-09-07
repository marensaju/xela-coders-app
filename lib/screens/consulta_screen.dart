import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// Pantalla de "Consulta de registro" de Xela Coders App.
///
/// ⚠️ VULNERABILIDAD INTENCIONAL #3: IDOR (Insecure Direct Object Reference).
/// La UI está pensada para que el usuario consulte SU PROPIO registro, pero
/// el backend (ver backend/server.js -> GET /api/registros/consulta) recibe
/// el identificador del documento como parámetro de consulta y NO valida que
/// el documento solicitado pertenezca al usuario autenticado en la sesión.
/// Cambiando libremente el valor del campo de texto, cualquier usuario
/// autenticado puede leer datos de un tercero.
///
/// La corrección correcta es: el backend debe derivar el identificador del
/// propio contexto de sesión/token (no confiar en el valor enviado por el
/// cliente), o si se permite un parámetro explícito, validar server-side que
/// `session.ownerDocumentId == requestedDocumentId` (u ownership equivalente)
/// antes de responder.
class ConsultaScreen extends StatefulWidget {
  const ConsultaScreen({super.key});

  @override
  State<ConsultaScreen> createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  final _documentIdCtrl = TextEditingController();
  final _api = ApiService();
  Map<String, dynamic>? _result;
  String? _error;

  Future<void> _consultar() async {
    setState(() => _error = null);
    try {
      // El documentId viaja tal cual como parámetro de la URL, sin ninguna
      // comprobación de que corresponda al usuario de la sesión activa.
      final data = await _api.get('/registros/consulta', queryParams: {
        'documentId': _documentIdCtrl.text,
      });
      setState(() => _result = data);
    } catch (e) {
      setState(() => _error = 'Error al consultar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta de registro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _documentIdCtrl,
              decoration:
                  const InputDecoration(labelText: 'Documento de identidad'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _consultar,
              child: const Text('Consultar'),
            ),
            const SizedBox(height: 16),
            if (_error != null) Text(_error!),
            if (_result != null) Text(_result.toString()),
          ],
        ),
      ),
    );
  }
}
