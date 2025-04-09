#!/bin/bash

# Tworzenie wolumenu
docker volume create nginx_data

# Uruchomienie kontenera Nginx z podmontowanym wolumenem
docker run -d --name my_nginx -p 8080:80 --volume nginx_data:/usr/share/nginx/html nginx

# Kopiowanie plików HTML do wolumenu
docker container cp ./html/index.html my_nginx:/usr/share/nginx/html/index.html

# Restart kontenera, aby załadował nowy plik
docker restart my_nginx

echo "Nginx działa na porcie 8080. Sprawdź w przeglądarce: http://localhost:8080"
