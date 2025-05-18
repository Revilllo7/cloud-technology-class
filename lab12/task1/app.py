from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"message": "Welcome to the API"}), 200

@app.route("/health")
def health():
    return jsonify({"status": "ok"}), 200

@app.route("/data")
def data():
    return jsonify({"data": [1, 2, 3, 4]}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
