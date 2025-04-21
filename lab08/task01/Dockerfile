FROM python:3.10

WORKDIR /app

# Skopiuj pliki do kontenera
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Uruchom
CMD ["python", "app.py"]
