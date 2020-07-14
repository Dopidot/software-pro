import flask
from flask import request, jsonify
from fitisly_model import start
from flask_cors import CORS

app = flask.Flask(__name__)
app.config["DEBUG"] = True
CORS(app)


@app.route('/', methods=['GET'])
def home():
    return jsonify({'status': 'OK'})


@app.route('/api/suggestionByProfile', methods=['GET'])
def api_get_suggestion():
    if 'height' in request.args:
        height = int(request.args['height'])
    else:
        return "Error: No height field provided. Please specify an height."

    if 'weight' in request.args:
        weight = int(request.args['weight'])
    else:
        return "Error: No weight field provided. Please specify an weight."

    if 'age' in request.args:
        age = int(request.args['age'])
    else:
        return "Error: No age field provided. Please specify an age."

    result = start(height, weight, age)
    response = {
        'value': result
    }

    # Use the jsonify function from Flask to convert our list of
    # Python dictionaries to the JSON format.
    return jsonify(response)


app.run()