const express = require('express');
const app = express();
const PORT = 4000;

app.get('/hello', (req, res) => {
  res.send('Hello from Microservice B!');
});

app.listen(PORT, () => console.log(`Microservice B running on port ${PORT}`));
