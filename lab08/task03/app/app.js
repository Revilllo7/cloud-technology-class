const express = require('express');
const redis = require('redis');
const { Pool } = require('pg');
const app = express();

app.use(express.json());

// Redis client
const redisClient = redis.createClient({
  url: 'redis://redis:6379'
});

// PostgreSQL pool
const pgPool = new Pool({
  host: 'postgres',
  user: 'myuser',
  password: 'mypassword',
  database: 'mydb',
  port: 5432,
});

// Redis routes
app.post('/message', async (req, res) => {
  const { id, text } = req.body;
  if (!id || !text) return res.status(400).json({ error: 'id and text are required' });
  await redisClient.set(id, text);
  res.json({ status: 'saved' });
});

app.get('/message/:id', async (req, res) => {
  const text = await redisClient.get(req.params.id);
  text ? res.json({ id: req.params.id, text }) : res.status(404).json({ error: 'not found' });
});

// PostgreSQL routes
app.post('/user', async (req, res) => {
  const { name, email } = req.body;
  try {
    const result = await pgPool.query('INSERT INTO users(name, email) VALUES($1, $2) RETURNING *', [name, email]);
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

app.get('/users', async (req, res) => {
  const result = await pgPool.query('SELECT * FROM users');
  res.json(result.rows);
});

// Start server only after Redis connects
(async () => {
  try {
    await redisClient.connect();
    app.listen(3000, () => {
      console.log('Server running on http://localhost:3000');
    });
  } catch (err) {
    console.error('Startup error:', err);
  }
})();
