from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "CI/CD pipeline working!"

app.run(host="0.0.0.0", port=80)