from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Witaj w aplikacji Flask uruchomionej przez Docker Compose!"
