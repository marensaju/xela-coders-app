# Mapeo a OWASP MASVS v2.1 / Mobile Top 10 / API Security Top 10

| # | Vulnerabilidad | MASVS | Mobile Top 10 (2024) | API Security Top 10 (2023) |
|---|---|---|---|---|
| 1 | Secretos hardcodeados en código/assets | MASVS-STORAGE-1, MASVS-CODE-2 | M10: Insufficient Cryptography / Extraneous Functionality | — |
| 2 | Firebase/backend sin autenticación, API key sin restricciones | MASVS-AUTH-1, MASVS-NETWORK | M8: Security Misconfiguration | API8: Security Misconfiguration |
| 3 | IDOR en endpoint de consulta | MASVS-AUTH-2 | M1: Improper Credential Usage / M6: Inadequate Privacy Controls | API1: Broken Object Level Authorization |
| 4 | Sin MFA | MASVS-AUTH-2 | M1: Improper Credential Usage | API2: Broken Authentication |
| 5 | SHA1 sin salt + pass-the-hash | MASVS-STORAGE, MASVS-AUTH | M10: Insufficient Cryptography | API2: Broken Authentication |
| 6 | Sin certificate pinning | MASVS-NETWORK-1 | M5: Insecure Communication | — |
| 7 | Storage local sin cifrar | MASVS-STORAGE-1 | M9: Insecure Data Storage | — |

## Referencias

- OWASP MASVS v2.1: https://mas.owasp.org/MASVS/
- OWASP Mobile Top 10: https://owasp.org/www-project-mobile-top-10/
- OWASP MASTG: https://mas.owasp.org/MASTG/
- OWASP API Security Top 10 (2023): https://owasp.org/API-Security/editions/2023/en/0x11-t10/
