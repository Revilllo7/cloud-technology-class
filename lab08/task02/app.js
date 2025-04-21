const express = require('express');
const redis = require('redis');
const app = express();

app.use(express.json());

const client = redis.createClient({
  url: 'redis://redis:6379'
});

client.connect().catch(console.error);

// Dodaj wiadomość
app.post('/message', async (req, res) => {
  const { id, text } = req.body;
  if (!id || !text) {
    return res.status(400).json({ error: 'id and text are required' });
  }
  await client.set(id, text);
  res.json({ status: 'saved' });
});

// Pobierz wiadomość
app.get('/message/:id', async (req, res) => {
  const text = await client.get(req.params.id);
  if (text) {
    res.json({ id: req.params.id, text });
  } else {
    res.status(404).json({ error: 'message not found' });
  }
});

app.listen(3000, () => {
  console.log('API running on http://localhost:3000');
});
