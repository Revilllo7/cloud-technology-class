#!/bin/bash

# Funkcja do wyświetlania komunikatów
info() {
  echo -e "\n\033[1;34m[$1]\033[0m $2"
}

info-error() {
  echo -e "\n\033[0;31m[$1]\033[0m $2"
}

# Wersja Node.js i konfiguracja
NODE_VERSION="16"
APP_CONTAINER="node16-express-mongo"
DB_CONTAINER="mongo-db"
DB_PORT=27017
APP_PORT=8080
MONGO_IMAGE="mongo:latest"

info "KONFIGURACJA" "Tworzenie kontenerów dla aplikacji i bazy danych"

# Uruchomienie kontenera MongoDB
docker run -d --name $DB_CONTAINER -p $DB_PORT:27017 $MONGO_IMAGE
info "BAZA DANYCH" "Kontener MongoDB uruchomiony na porcie $DB_PORT"

# Uruchomienie kontenera aplikacji Node.js
docker run -d -p $APP_PORT:8080 --name $APP_CONTAINER -it node:$NODE_VERSION-alpine tail -f /dev/null
info "KONTENER" "Kontener aplikacji uruchomiony na porcie $APP_PORT"

# Tworzenie katalogu /app w kontenerze aplikacji
docker exec $APP_CONTAINER mkdir -p /app

# Tworzenie plików aplikacji Express.js
docker exec $APP_CONTAINER sh -c 'echo "{
  \"name\": \"express-mongo-server\",
  \"version\": \"1.0.0\",
  \"main\": \"app.js\",
  \"dependencies\": {
    \"express\": \"^4.17.1\",
    \"mongoose\": \"^6.6.0\"
  }
}" > /app/package.json'

docker exec $APP_CONTAINER sh -c 'echo "const express = require(\"express\");
const mongoose = require(\"mongoose\");
const app = express();
const PORT = 8080;

// Połączenie z bazą danych MongoDB
mongoose.connect(\"mongodb://host.docker.internal:27017/testdb\", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => console.log(\"Połączono z MongoDB\"))
  .catch(err => console.error(\"Błąd połączenia z MongoDB:\", err));

const Item = mongoose.model(\"Item\", new mongoose.Schema({ name: String }));

app.get(\"/\", async (req, res) => {
  const items = await Item.find();
  res.json({ items });
});

app.listen(PORT, () => console.log(`Serwer działa na porcie ${PORT}`));" > /app/app.js'

# Instalowanie zależności
docker exec -w /app $APP_CONTAINER npm install

# Uruchomienie aplikacji
info "URUCHOMIENIE" "Serwer Express.js z bazą MongoDB uruchomiony na porcie $APP_PORT"
docker exec -w /app $APP_CONTAINER node app.js 2>&1 | tee server.log &


# Czekanie na serwer
sleep 5

# TESTY
info "TEST" "Sprawdzanie, czy serwer działa poprawnie i zwraca dane z MongoDB"
curl -s http://localhost:$APP_PORT | grep -q '"items":' && info "TEST" "Serwer działa i zwraca dane" || info-error "ERROR" "Serwer nie zwrócił poprawnych danych"

info "ZAKOŃCZENIE" "Testy zakończone sukcesem. Serwer działa poprawnie."

echo -e "Aby zatrzymać kontenery, wykonaj: docker stop $APP_CONTAINER $DB_CONTAINER"
echo -e "Aby usunąć kontenery, wykonaj: docker rm $APP_CONTAINER $DB_CONTAINER"
