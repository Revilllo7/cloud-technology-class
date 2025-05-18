const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
    res.json({ message: "Hello from ARM64 Node.js API!" });
});

app.listen(port, () => {
    console.log(`API server listening on port ${port}`);
});
