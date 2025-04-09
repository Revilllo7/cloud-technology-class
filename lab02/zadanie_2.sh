#!/bin/bash

# Funkcja do wyświetlania komunikatów
info() {
  echo -e "\n\033[1;34m[$1]\033[0m $2"
}

# Wersja Node.js
NODE_VERSION="14"
CONTAINER_NAME="node14-express-server"

info "KONFIGURACJA" "Tworzenie kontenera z Node.js w wersji $NODE_VERSION"

# Tworzenie i uruchamianie kontenera
CONTAINER_ID=$(docker run -d -p 8080:8080 --name $CONTAINER_NAME -it node:$NODE_VERSION-alpine tail -f /dev/null)

info "KONTENER" "Utworzono kontener o ID: $CONTAINER_ID"

# Tworzenie katalogu /app w kontenerze
docker exec $CONTAINER_ID mkdir -p /app

# Tworzenie plików aplikacji Express.js
docker exec $CONTAINER_ID sh -c 'echo "{
  \"name\": \"express-server\",
  \"version\": \"1.0.0\",
  \"main\": \"app.js\",
  \"dependencies\": {
    \"express\": \"^4.17.1\"
  }
}" > /app/package.json'

docker exec $CONTAINER_ID sh -c 'echo "const express = require(\"express\");
const app = express();
app.get(\"/\", (req, res) => {
  res.json({ datetime: new Date().toISOString() });
});
app.listen(8080, () => console.log(\"Server running on port 8080\"));" > /app/app.js'

# Instalowanie zależności
docker exec -w /app $CONTAINER_ID npm install

# Uruchomienie aplikacji
docker exec -w /app $CONTAINER_ID node app.js &

info "URUCHOMIENIE" "Serwer Express.js uruchomiony na porcie 8080"

# Czekanie na uruchomienie serwera
sleep 2

# TESTY
info "TEST" "Sprawdzanie, czy serwer działa poprawnie"
RESPONSE=$(curl -s http://localhost:8080)
DATETIME=$(echo $RESPONSE | grep -o 'datetime":"[^"]*' | cut -d '"' -f3)

if [[ -n "$DATETIME" ]]; then
  info "TEST" "Serwer zwrócił poprawną odpowiedź: $RESPONSE"
else
  echo -e "\n\033[1;31m[ERROR]\033[0m Serwer nie zwrócił poprawnej odpowiedzi: $RESPONSE"
  exit 1
fi

info "ZAKOŃCZENIE" "Testy zakończone sukcesem. Serwer działa poprawnie."

echo -e "\nAby zatrzymać kontener, wykonaj: docker stop $CONTAINER_ID"
echo -e "Aby usunąć kontener, wykonaj: docker rm $CONTAINER_ID"
