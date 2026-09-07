/**
 * Xela Coders App - Backend mock VULNERABLE (demo educativa)
 *
 * Reproduce, del lado servidor, dos de las vulnerabilidades de la app:
 *   - IDOR en GET /api/registros/consulta (no valida ownership del documentId solicitado)
 *   - Pass-the-hash en POST /api/auth/login (compara el hash SHA1 recibido
 *     tal cual contra el almacenado, en vez de derivarlo server-side a
 *     partir de una contraseña en texto plano)
 *
 * Todos los datos son ficticios. No usar como referencia de diseño seguro.
 */

const express = require('express');
const app = express();
app.use(express.json());

// "Base de datos" en memoria, con usuarios y documentIds ficticios.
const USERS = [
  { username: 'jgarcia', documentId: '1111111111111', passwordHash: sha1('Xela2026!') },
  { username: 'mlopez', documentId: '2222222222222', passwordHash: sha1('CoderVuln1') },
];

function sha1(text) {
  return require('crypto').createHash('sha1').update(text).digest('hex');
}

/**
 * ⚠️ VULNERABILIDAD #5 (lado servidor): pass-the-hash.
 * El cliente envía `passwordHash` (SHA1 calculado en el dispositivo) y este
 * endpoint lo compara DIRECTAMENTE contra el hash almacenado. Quien posea
 * el hash -sin conocer la contraseña real- puede autenticarse.
 */
app.post('/api/auth/login', (req, res) => {
  const { username, passwordHash } = req.body;
  const user = USERS.find(u => u.username === username);

  if (user && user.passwordHash === passwordHash) {
    return res.status(200).json({ status: 'ok', documentId: user.documentId });
  }
  return res.status(401).json({ status: 'error', message: 'credenciales inválidas' });

  // No hay ningún paso adicional de MFA en este flujo (vulnerabilidad #4).
});

/**
 * ⚠️ VULNERABILIDAD #3: IDOR.
 * Este endpoint responde con el registro que coincide con el documentId
 * recibido por query string, SIN verificar que ese documento pertenezca al
 * usuario autenticado de la sesión (de hecho, este mock ni siquiera exige un
 * token de sesión válido, para reflejar el patrón: la única "autenticación"
 * es la API key estática de env_config.dart, compartida por todos los
 * usuarios de la app).
 */
app.get('/api/registros/consulta', (req, res) => {
  const { documentId } = req.query;
  const user = USERS.find(u => u.documentId === documentId);

  if (!user) {
    return res.status(404).json({ status: 'error', message: 'no encontrado' });
  }

  // Se devuelve el registro completo de CUALQUIER documento solicitado, sin
  // comprobar si pertenece a quien hace la petición.
  return res.status(200).json({
    status: 'ok',
    data: { username: user.username, documentId: user.documentId },
  });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Xela Coders App backend (VULNERABLE, demo) escuchando en :${PORT}`);
});
