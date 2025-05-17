const express = require('express');
const axios = require('axios');
const app = express();
const PORT = 3000;

app.get('/call-b', async (req, res) => {
  try {
    const response = await axios.get('http://microservice-b-service:4000/hello');
    res.send(`Response from B: ${response.data}`);
  } catch (err) {
    res.status(500).send('Error contacting microservice B');
  }
});

app.listen(PORT, () => console.log(`Microservice A running on port ${PORT}`));
