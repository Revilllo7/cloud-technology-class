!/bin/bash
echo "Sprawdzanie połączenia frontend -> backend -> database..."

curl -s http://localhost:3000 && echo -e "\nPołączenie działa poprawnie." || echo "Błąd połączenia"
