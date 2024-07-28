

import datetime
import json
import os
from functools import wraps
from pathlib import Path
from typing import List, Tuple

from flask import Flask, abort, jsonify, make_response, request
from stix2 import TLP_WHITE, Vulnerability
from stix2.base import _STIXBase
from taxii2client.v21 import ApiRoot, Server, Status

from taxii_client import taxii_utils

taxii_server_url = os.getenv("TAXII_SERVER_URL", "http://kubernetes.docker.internal:32222")
collection_id = os.getenv("COLLECTION_ID", "vulnerabilities")
api_root_name = os.getenv("API_ROOT_NAME", "app1")
medallion_username = os.getenv("MEDALLION_USERNAME", "medallion_admin")
medallion_user_password = os.getenv("MEDALLION_USER_PASSWORD", "Test.1234")
taxii_proxy_port = os.getenv("TAXII_PROXY_PORT", 8080)
taxii_proxy_host = os.getenv("TAXII_PROXY_HOST", "0.0.0.0")

def create_stix_vulnerability(vuln: Vulnerability):
    vuln_stix = Vulnerability(
        name=vuln["title"],
        description=f"A vulnerability in {vuln['resource']} fixed in version {vuln['fixedVersion']}.",
        external_references=[
            {
                "source_name": "CVE",
                "external_id": vuln["vulnerabilityID"],
                "url": vuln["primaryLink"]
            }
        ],
        created=datetime.datetime.strptime(vuln["publishedDate"], "%Y-%m-%dT%H:%M:%SZ"),
        modified=datetime.datetime.strptime(vuln["lastModifiedDate"], "%Y-%m-%dT%H:%M:%SZ"),
        labels=[vuln["severity"]],
        object_marking_refs=[
            TLP_WHITE  # Example marking definition, adjust as needed
        ]
    )
    return vuln_stix
            
def add_collection_objects(server, api_root_name, collection_id, object_list: List[_STIXBase]) -> Tuple[str, str]:
    serialized_objects = { "objects": [json.loads(x.serialize(pretty=True)) for x in object_list]}

    api_root :ApiRoot = taxii_utils.get_api_root_name_from_server(server, api_root_name)
    collection = taxii_utils.get_api_root_name_from_api_root(api_root, collection_id)
    try:
        if collection:
            response: Status = collection.add_objects(serialized_objects)
            print(" " + response.status, response.url)
            return response.status, response.url
        else:
            print("Collection does not exist")
            return False, "Collection does not exist"
    except Exception as exc:
        return False, str(exc) 

import os

from flask import Flask


def token_required(f):
    @wraps(f)
    def decorator(*args, **kwargs):
        token = None
        # ensure the token is passed with the headers
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        if not token: # throw error if no token provided
            return make_response(jsonify({"message": "A valid access token is missing!"}), 401)

        if token not in app.config["valid_client_tokens"]:
            return make_response(jsonify({"message": "Invalid token."}), 401)

        return f(*args, **kwargs)
    return decorator

def create_app():
    app = Flask(__name__)
    tokens_json = json.loads(Path("auth.json").read_text())
    app.config["valid_client_tokens"] = set(tokens_json["valid_client_tokens"])
    
    @app.route('/vulnerabilities', methods=['POST'])
    @token_required
    def add_vulnerability():
        server = Server(f'{taxii_server_url}/taxii2/', user=medallion_username, password=medallion_user_password)

        vulnerability_data = request.json
        print("Recieved:" + str(vulnerability_data))
        
        try:
            objects=[create_stix_vulnerability(vulnerability_data)]
        except Exception as exc:
            abort(400, 'Input data parse error' + str(exc)) 
            
        try:
            status, status_url = add_collection_objects(server, api_root_name, collection_id, objects)
        except Exception as exc:
            abort(500, 'Error' + str(exc)) 
        
        return jsonify({"status": status, "status_url": status_url})

    return app

app = create_app()
if __name__ == "__main__":
    print(f"taxii_server_url: {taxii_server_url}")
    print(f"collection_id: {collection_id}")
    print(f"managed api_root_name: {api_root_name}")
    print(f"medallion_username: {medallion_username}")
    print(f"taxii_proxy_port: {taxii_proxy_port}")
    print(f"taxii_proxy_host: {taxii_proxy_host}")
    
    app.run(host=taxii_proxy_host, port=taxii_proxy_port, debug=False)