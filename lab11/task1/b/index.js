const express = require('express');
const app = express();
const PORT = 4000;
const mongoose = require('mongoose');
const dbUser = process.env.DB_USER;
const dbPass = process.env.DB_PASS;
const dbHost = process.env.DB_HOST;
const dbPort = process.env.DB_PORT;
const dbName = process.env.DB_NAME;

app.get('/hello', (req, res) => {
  res.send('Hello from Microservice B!');
});

mongoose.connect(`mongodb://${dbUser}:${dbPass}@${dbHost}:${dbPort}/${dbName}?authSource=admin`)
  .then(() => {
    console.log('Mongo connected');
    app.listen(PORT, () => console.log(`Microservice B running on port ${PORT}`));
  })
  .catch(err => console.error('Mongo error:', err));