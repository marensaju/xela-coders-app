# Xela Coders App (Demo Vulnerable)

> ⚠️ **PROYECTO EDUCATIVO — NO USAR EN PRODUCCIÓN**
> Esta es una aplicación móvil **intencionalmente vulnerable**, construida desde cero
> para fines de investigación en seguridad y divulgación en conferencias.
> Todos los datos, claves, organización ("Xela Coders") y usuarios son **ficticios**.
> No contiene código, secretos ni datos reales de ningún cliente o auditoría.

## ¿Qué es esto?

Una app Flutter/Dart + backend Node.js que simula una aplicación móvil de una organización
("Xela Coders App") y reproduce, de forma controlada y documentada, un conjunto de
patrones de vulnerabilidad **frecuentes en apps móviles Flutter mal aseguradas**,
alineados con OWASP MASVS v2.1 y OWASP Mobile Top 10.

El objetivo es tener un caso de estudio público, reproducible y sin restricciones
de confidencialidad, en binarios Flutter/Dart compilados en AOT.

## Vulnerabilidades implementadas (v1)

| # | Vulnerabilidad | Ubicación | Categoría MASVS |
|---|---|---|---|
| 1 | Secretos hardcodeados (API keys en `.env` embebido + colección Postman) | `lib/config/env_config.dart`, `assets/postman_collection_demo.json` | MASVS-STORAGE-1, MASVS-CODE-2 |
| 2 | Backend/Firebase mal configurado (lectura/escritura sin autenticación) | `backend/firebase-rules-demo.json`, `lib/services/firebase_service.dart` | MASVS-NETWORK, MASVS-AUTH |
| 3 | IDOR en endpoint de consulta (manipulación de identificador) | `backend/server.js` (`/api/registros/consulta`), `lib/screens/consulta_screen.dart` | MASVS-AUTH-2, OWASP API1 |
| 4 | Ausencia de MFA | `lib/services/auth_service.dart` | MASVS-AUTH-2 |
| 5 | Hash de contraseña SHA1 sin salt + pass-the-hash | `lib/services/auth_service.dart`, `backend/server.js` | MASVS-STORAGE, MASVS-AUTH |
| 6 | Sin certificate pinning | `lib/services/api_service.dart` | MASVS-NETWORK-1 |
| 7 | Almacenamiento local sin cifrar (en desarrollo) (PDFs/documentos) | `lib/services/storage_service.dart` | MASVS-STORAGE-1 |

Ver `docs/OWASP_MASVS_MAPPING.md` para el detalle técnico de cada hallazgo y
`VULNERABILITIES.md` para el paso a paso de explotación de cada uno.

Ver `PROGRESS.md` para el estado de construcción del proyecto (útil si esto se
retoma en otra sesión de trabajo).

## Estructura

```
xela-coders-app/
├── lib/                        # App Flutter
│   ├── config/env_config.dart  # (1) secretos hardcodeados
│   ├── services/
│   │   ├── auth_service.dart   # (4)(5) sin MFA, SHA1 sin salt
│   │   ├── api_service.dart    # (6) sin pinning
│   │   ├── firebase_service.dart # (2) firebase abierto
│   │   └── storage_service.dart  # (7) storage sin cifrar
│   └── screens/                # login, home, perfil, consulta (IDOR)
├── backend/                     # Mock backend Node/Express
│   ├── server.js                # (3)(5) IDOR + pass-the-hash
│   └── firebase-rules-demo.json # (2) reglas abiertas
├── assets/postman_collection_demo.json # (1) colección con secretos
└── docs/OWASP_MASVS_MAPPING.md
```

## Cómo correrlo

**Backend:**
```bash
cd backend
npm install
node server.js
```

**App Flutter** (requiere Flutter SDK instalado, ver flutter.dev):
```bash
flutter pub get
flutter run
```

## Licencia y uso

Uso educativo. MIT License. No se recomienda compilar y publicar esta app en
tiendas de aplicaciones reales.
