# Etap 1
FROM ubuntu:latest AS builder

# Instalacja zależności
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# Katalog roboczy
WORKDIR /app

# Kopiowanie
COPY app /app

# Instalacja zależności
RUN npm install

# Budowanie aplikacji
RUN npm run build

# Etap 2
FROM nginx:alpine

# Kopiowanie do Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Kopiowanie pliku conf nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Otworzenie portu
EXPOSE 80

# Uruchomienie Nginx
CMD ["nginx", "-g", "daemon off;"]
