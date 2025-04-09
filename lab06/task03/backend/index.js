const express = require('express');
const mysql = require('mysql2/promise');
const app = express();
const port = 3000;

const MAX_RETRIES = 10;
const RETRY_INTERVAL_MS = 3000;

async function connectWithRetry(retries = MAX_RETRIES) {
  while (retries > 0) {
    try {
      const connection = await mysql.createConnection({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
      });
      console.log("Połączono z bazą danych!");
      return connection;
    } catch (err) {
      console.error(`Błąd połączenia z bazą: ${err.message}`);
      retries--;
      if (retries === 0) {
        console.error("Nie udało się połączyć z bazą danych po wielu próbach. Zamykanie aplikacji.");
        process.exit(1);
      }
      console.log(`Ponawianie połączenia za ${RETRY_INTERVAL_MS / 1000} sekund... (${MAX_RETRIES - retries}/${MAX_RETRIES})`);
      await new Promise(res => setTimeout(res, RETRY_INTERVAL_MS));
    }
  }
}

(async () => {
  const db = await connectWithRetry();

  app.get('/', async (req, res) => {
    try {
      const [rows] = await db.query('SELECT NOW() as time');
      res.send(`Czas bazy danych: ${rows[0].time}`);
    } catch (err) {
      console.error('Błąd zapytania do bazy danych:', err.message);
      res.status(500).send('Błąd bazy danych');
    }
  });

  app.listen(port, () => {
    console.log(`Backend działa na porcie ${port}`);
  });
})();
