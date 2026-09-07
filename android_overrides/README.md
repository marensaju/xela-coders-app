# android_overrides

Estos archivos NO son parte del scaffolding que genera `flutter create`.
Se copian **encima** de la carpeta `android/` después de haberla generado.

## Cómo usarlos

Desde la raíz del proyecto, una vez que exista la carpeta `android/`:

**Windows (PowerShell):**
```powershell
Copy-Item -Path .\android_overrides\app\src\main\AndroidManifest.xml `
          -Destination .\android\app\src\main\AndroidManifest.xml -Force

New-Item -ItemType Directory -Force -Path .\android\app\src\main\res\xml | Out-Null
Copy-Item -Path .\android_overrides\app\src\main\res\xml\network_security_config.xml `
          -Destination .\android\app\src\main\res\xml\network_security_config.xml -Force
```

**Linux/macOS/WSL:**
```bash
cp android_overrides/app/src/main/AndroidManifest.xml android/app/src/main/AndroidManifest.xml
mkdir -p android/app/src/main/res/xml
cp android_overrides/app/src/main/res/xml/network_security_config.xml android/app/src/main/res/xml/
```

## Qué cambian respecto al manifest por defecto

| Ajuste | Efecto |
|---|---|
| `android:usesCleartextTraffic="true"` | Permite HTTP plano hacia el backend mock local |
| `android:networkSecurityConfig` | Apunta a la config que confía en CAs de usuario (permite interceptar con Burp) |
| `android:allowBackup="true"` | Permite extraer los archivos de la app vía `adb backup` (demuestra vuln #7) |
| `<uses-permission INTERNET>` | Necesario para las llamadas de red |

Todos estos ajustes son **intencionalmente inseguros** y forman parte del
propósito educativo del proyecto.

## Nota sobre el applicationId

Tras `flutter create`, edita `android/app/build.gradle` (o `build.gradle.kts`)
y verifica que el `applicationId` sea:

```
applicationId = "com.xelacoders.demo"
```

Ese es el package que usan los comandos de `VULNERABILITIES.md`
(`adb shell run-as com.xelacoders.demo ...`).
