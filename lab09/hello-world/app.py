from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World from Kubernetes! - version 2.0, now with more crabs"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
