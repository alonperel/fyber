from flask import Flask, request
import requests
import json
import base64

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello!"

@app.route('/get_value')
def get_value():
#curl http://localhost:8500/v1/kv/db/config/max-connections
    search_key = request.args['key']
    consule_url = 'http://server:8500/v1/kv/homework/{search_key}'.format(search_key=search_key)
    response = requests.get(consule_url)
    res = json.loads(response.text)[0]
    return base64.b64decode(res["Value"])


@app.route('/set_value')
def set_value():
    new_key_name = request.args['key']
    new_key_value = request.args['value']
    consule_url = 'http://server:8500/v1/kv/homework/{new_key_name}'.format(new_key_name=new_key_name)
    req = requests.put(consule_url, data = new_key_value)
    if req.text == 'true':
    	return "Success"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
