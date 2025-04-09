#!/bin/bash

# Tworzenie wolumenów
docker volume create nodejs_data
docker volume create nginx_data
docker volume create all_volumes

# Uruchomienie kontenera Node.js z wolumenem nodejs_data
docker run -d --name my_node -v nodejs_data:/app node:latest sleep infinity

# Uruchomienie kontenera Nginx z wolumenem nginx_data
docker run -d --name my_nginx -v nginx_data:/usr/share/nginx/html nginx

# Kopiowanie przykładowych plików do wolumenów
docker container cp ./node_app/app.js my_node:/app/app.js
docker container cp ./html/index.html my_nginx:/usr/share/nginx/html/index.html

# Restart kontenerów, aby załadowały nowe pliki
docker restart my_node
docker restart my_nginx

# Kopiowanie plików z Nginx do all_volumes
docker run --rm --volumes-from my_nginx -v all_volumes:/backup alpine sh -c "cp -r /usr/share/nginx/html/* /backup/"

# Kopiowanie plików z Node.js do all_volumes
docker run --rm --volumes-from my_node -v all_volumes:/backup alpine sh -c "cp -r /app/* /backup/"

echo "Kontenery i wolumeny zostały utworzone. Pliki zostały skopiowane do all_volumes."
