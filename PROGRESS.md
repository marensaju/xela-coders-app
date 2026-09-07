# PROGRESS — Estado de construcción

> Este archivo es el "punto de guardado" del proyecto: registra las decisiones
> de alcance ya tomadas y el estado de cada archivo, de modo que el desarrollo
> pueda retomarse en otra sesión sin repetir trabajo ni re-establecer contexto.

## Decisiones de alcance (fijas)

- Stack: Flutter/Dart real para la app móvil, Node.js/Express para el backend mock.
- Organización ficticia: **Xela Coders**. Package: `com.xelacoders.demo`.
- Alcance de vulnerabilidades v1 (7, todas técnicas, ver README): secretos
  hardcodeados, Firebase/backend abierto, IDOR, sin MFA, SHA1 sin salt +
  pass-the-hash, sin certificate pinning, storage local sin cifrar.
- Fuera de alcance v1 (posible v2): falta de logout, falta de
  ofuscación/build flags, falta de detección de root/jailbreak/Frida.
- Todos los secretos, claves, usuarios y datos en este repo son
  **ficticios/dummy**, nunca reales ni derivados de auditorías de terceros.

## Estado por archivo

| Archivo | Estado | Notas |
|---|---|---|
| README.md | ✅ Hecho | |
| PROGRESS.md | ✅ Hecho | este archivo |
| VULNERABILITIES.md | ✅ Hecho | guía de explotación paso a paso |
| docs/OWASP_MASVS_MAPPING.md | ✅ Hecho | |
| pubspec.yaml | ✅ Hecho | sin deps de Firebase (ver nota abajo) |
| lib/config/env_config.dart | ✅ Hecho | vuln #1 |
| assets/postman_collection_demo.json | ✅ Hecho | vuln #1 |
| lib/models/user.dart | ✅ Hecho | |
| lib/services/auth_service.dart | ✅ Hecho | vuln #4, #5 |
| lib/services/api_service.dart | ✅ Hecho | vuln #6 |
| lib/services/firebase_service.dart | ✅ Hecho | vuln #2 |
| lib/services/storage_service.dart | ✅ Hecho | vuln #7 |
| lib/screens/login_screen.dart | ✅ Hecho | |
| lib/screens/home_screen.dart | ✅ Hecho | |
| lib/screens/consulta_screen.dart | ✅ Hecho | vuln #3 (UI del IDOR) |
| lib/main.dart | ✅ Hecho | |
| backend/server.js | ✅ Hecho | vuln #3, #5 (lado servidor) |
| backend/package.json | ✅ Hecho | |
| backend/firebase-rules-demo.json | ✅ Hecho | vuln #2 |
| android_overrides/ | ✅ Hecho | manifest + network_security_config |
| **Compilación y ejecución** | ✅ **Verificado** | corre en emulador contra el backend mock |

## Entorno de build verificado

Combinación con la que el proyecto compiló y corrió correctamente:

- Windows 11 (25H2), Flutter **3.47.2** stable, Node.js **v24.19.0**
- Android SDK 36.1.0, emulador AVD
- Android SDK **Command-line Tools 22.0** (ver troubleshooting)

### Troubleshooting del montaje (tropiezos reales encontrados)

| Síntoma | Causa | Solución |
|---|---|---|
| `flutter doctor --android-licenses` imprime avisos de deprecación y sale sin preguntar nada | Command-line Tools **23.0+** deprecó `sdkmanager`; Flutter todavía lo invoca. Bug abierto (flutter/flutter #191487, #191558) | Bajar a Command-line Tools **22.0** en Android Studio → SDK Tools → *Show Package Details* |
| Build falla con `Package ndk not found` y `exit value -1073740791 (0xC0000409)` | Mismo origen: Gradle llama a `sdkmanager.bat` para bajar el NDK y el shim crashea | Mismo downgrade a 22.0. Opcionalmente instalar el NDK a mano desde SDK Tools |
| `Building with plugins requires symlink support` | Windows exige Modo de desarrollador para crear symlinks sin privilegios | `start ms-settings:developers` → activar **Modo de desarrollador** |
| `npm` no se reconoce | Node no instalado en Windows (estarlo en WSL2 no cuenta: son entornos separados) | `winget install OpenJS.NodeJS.LTS` y **reiniciar la terminal/VS Code** para refrescar el PATH |
| `npm.ps1 ... la ejecución de scripts está deshabilitada` | ExecutionPolicy en `Restricted` | `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned` |
| `curl` en PowerShell pide confirmación y devuelve un objeto envuelto | En PowerShell `curl` es alias de `Invoke-WebRequest` | Usar **`curl.exe`** en las pruebas |

### Notas de configuración

- **`pubspec.yaml` no lleva `firebase_core` / `firebase_database`.** El servicio
  de Firebase de la demo usa REST plano (que es justo como se verifica la
  exposición sin autenticación), y añadir esas dependencias exigiría un
  `google-services.json` real para poder compilar.
- **URL del backend:** `lib/config/env_config.dart` debe apuntar a
  `http://10.0.2.2:3000/api` para el emulador AVD (`10.0.2.2` es como el
  emulador alcanza el localhost del anfitrión). En dispositivo físico, usar la
  IP LAN de la PC.
- **El scaffolding Android se genera aparte.** El repo no versiona `android/`
  ni `ios/`; se crean con `flutter create` y luego se aplican los archivos de
  `android_overrides/` encima (ver su README).

## Cómo levantar el proyecto desde cero

```bash
# 1. Scaffolding
flutter create --org com.xelacoders --project-name xela_coders_app xela_coders_app

# 2. Copiar encima lib/, assets/, .env, pubspec.yaml, backend/, docs/
# 3. Aplicar android_overrides/ (ver android_overrides/README.md)
# 4. Ajustar apiBaseUrl a http://10.0.2.2:3000/api

flutter pub get

# 5. Backend (terminal aparte)
cd backend && npm install && node server.js

# 6. App (emulador arrancado)
flutter run
```

Credenciales de prueba (ficticias): ver `backend/server.js`.

## Próximo paso sugerido (si se retoma)

1. Generar el APK de **release** (`flutter build apk --release`) — necesario
   para el reversing: el build de debug va en JIT y no expone los strings
   igual que el AOT.
2. Correr el análisis estático sobre ese APK (apktool, apkleaks, gitleaks,
   Blutter) y capturar evidencia de la vuln #1.
3. Configurar Burp/mitmproxy contra el emulador para capturar evidencia de
   la vuln #6.
4. Decidir si se agrega v2 (logout, ofuscación, anti-root) o se deja v1.


## Historial de sesiones

- **Sesión 1**: estructura completa generada, las 7 vulnerabilidades v1
  implementadas en código fuente. Pendiente: compilar y probar en un entorno
  con Flutter SDK instalado.
- **Sesión 2**: limpieza de nomenclatura. Se renombró la ruta base de la API
  y el endpoint de consulta a términos genéricos (`XCAPI`,
  `/registros/consulta`), y el identificador a `documentId`, para que el
  proyecto no arrastre nomenclatura de ningún sistema externo.
- **Sesión 3**: montaje del entorno de build y **primera ejecución exitosa**.
  Se añadió `android_overrides/`, se quitaron las dependencias de Firebase que
  rompían el build, y se documentó el troubleshooting del entorno (tabla
  arriba). Backend verificado por `curl.exe`; app corriendo en emulador.
