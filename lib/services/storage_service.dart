import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

/// Servicio de almacenamiento local de documentos de Xela Coders App.
///
/// ⚠️ VULNERABILIDAD INTENCIONAL #7: Almacenamiento local sin cifrar.
/// Los documentos (ej. constancias, reportes en PDF) descargados desde el
/// backend se guardan tal cual en el directorio de documentos de la app,
/// sin ningún cifrado a nivel de archivo.
///
/// En Android, si el dispositivo está rooteado o si se hace un backup con
/// `adb backup` (en versiones/target SDK que lo permiten), o si la app no
/// marca `android:allowBackup="false"`, estos archivos pueden extraerse en
/// texto plano. Lo mismo aplica a iOS si el dispositivo está jailbreakeado
/// o mediante extracción del contenedor de la app.
///
/// La corrección correcta es cifrar el contenido antes de escribirlo a
/// disco, usando una clave derivada y protegida por Android Keystore /
/// iOS Keychain (por ejemplo con `flutter_secure_storage` para la clave, y
/// AES-GCM para el contenido del archivo), en vez de escribir el PDF plano.
class StorageService {
  Future<File> savePdfUnencrypted(String filename, Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    // Escritura directa, sin ninguna capa de cifrado.
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<Uint8List> readPdf(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    return await file.readAsBytes();
  }
}
