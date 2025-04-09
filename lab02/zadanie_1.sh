#!/bin/bash

# Funkcja do wyświetlania komunikatów
info() {
  echo -e "\n\033[1;34m[$1]\033[0m $2"
}

info-error() {
  echo -e "\n\033[0;31m[$1]\033[0m $2"
}


# Wersja Node.js
NODE_VERSION="12"
CONTAINER_NAME="node12-http-server"

info "KONFIGURACJA" "Tworzenie kontenera z Node.js w wersji $NODE_VERSION"

# Tworzenie i uruchamianie kontenera
CONTAINER_ID=$(docker run -d -p 8080:8080 --name $CONTAINER_NAME -it node:$NODE_VERSION-alpine tail -f /dev/null)

info "KONTENER" "Utworzono kontener o ID: $CONTAINER_ID"

# Tworzenie katalogu /app w kontenerze
docker exec $CONTAINER_ID mkdir -p /app

# Tworzenie pliku app.js w kontenerze
docker exec $CONTAINER_ID sh -c 'echo "const http = require(\"http\");
const server = http.createServer((req, res) => {
  res.writeHead(200, {\"Content-Type\": \"text/plain\"});
  res.end(\"Hello World\");
});
server.listen(8080, () => console.log(\"Server running on port 8080\"));" > /app/app.js'

# Uruchomienie serwera
docker exec -w /app $CONTAINER_ID node app.js &

info "URUCHOMIENIE" "Serwer HTTP uruchomiony na porcie 8080"

# Czekanie na serwer
sleep 2

# TESTY
info "TEST" "Sprawdzanie, czy serwer działa poprawnie"
RESPONSE=$(curl -s http://localhost:8080)
EXPECTED_RESPONSE="Hello World"

if [[ "$RESPONSE" == "$EXPECTED_RESPONSE" ]]; then
  echo -e "Serwer zwrócił poprawną odpowiedź: $RESPONSE"
else
  info-error "ERROR" "Serwer zwrócił niepoprawną odpowiedź: $RESPONSE"
  exit 1
fi

info "ZAKOŃCZENIE" "Testy zakończone sukcesem. Serwer działa poprawnie."

echo -e "Aby zatrzymać kontener, wykonaj: docker stop $CONTAINER_ID"
echo -e "Aby usunąć kontener, wykonaj: docker rm $CONTAINER_ID"

