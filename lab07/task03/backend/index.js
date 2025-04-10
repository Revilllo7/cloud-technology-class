const express = require('express');
const { MongoClient } = require('mongodb');
const app = express();
const PORT = 3003;

const uri = "mongodb://db:27017";
const client = new MongoClient(uri);

app.get('/users', async (req, res) => {
  try {
    await client.connect();
    const collection = client.db("test").collection("users");
    const users = await collection.find({}).toArray();
    res.json(users);
  } catch (err) {
    console.error(err);
    res.status(500).send("Błąd serwera");
  }
});

app.listen(PORT, () => {
  console.log(`API działa na porcie ${PORT}`);
});
