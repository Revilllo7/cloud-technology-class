# Argumenty
ARG PYTHON_VERSION=3.10
ARG APP_PORT=3000

# Oficjalny obraz alpine
FROM python:${PYTHON_VERSION}-alpine

# Zmienne środowiskowe
ENV PYTHON_VERSION=${PYTHON_VERSION}
ENV APP_PORT=${APP_PORT}

# Katalog roboczy
WORKDIR /app

# Kopiowanie
COPY myapp /app

# Instalacja zależności
RUN pip install --no-cache-dir -r requirements.txt

# Utworzenie woluminu
VOLUME [ "/app/data" ]

# Otworzenie portu
EXPOSE ${APP_PORT}

# Uruchomienie aplikacji
CMD ["python", "app.py"]
