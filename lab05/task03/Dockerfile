# Użycie ARG do określenia wersji Pythona (domyślnie 3.10)
ARG PYTHON_VERSION=3.10

# Użycie oficjalnego obrazu Pythona z podaną wersją
FROM python:${PYTHON_VERSION}

# Ustawienie katalogu roboczego w kontenerze
WORKDIR /app

# Skopiowanie aplikacji do obrazu
COPY myapp /app

# Instalacja zależności aplikacji
RUN pip install --no-cache-dir -r requirements.txt

# Otworzenie portu (jeśli aplikacja go używa, np. Flask)
EXPOSE 3000

# Uruchomienie aplikacji
CMD ["python", "app.py"]
