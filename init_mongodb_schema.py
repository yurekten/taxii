import os
import time

from pymongo import MongoClient

taxii_server_url = os.getenv("TAXII_SERVER_URL" , f"http://kubernetes.docker.internal:32222")
mongodb_url = os.getenv("MONGODB_URL","mongodb://mongodb_admin:Test.123456@kubernetes.docker.internal:32517/?authSource=admin")
collection_id = os.getenv("COLLECTION_ID", "vulnerabilities")
default_root_api_name = os.getenv("DEFAULT_ROOT_API_NAME", "app1")
root_api_names_str = os.getenv("ROOT_API_NAMES", "app1,app2")
root_api_names = [x.strip() for x in root_api_names_str.split(",")]

print(f"taxii_server_url: {taxii_server_url}")
print(f"collection_id: {collection_id}")
print(f"managed api_root_names: {root_api_names_str}")
# print(f"mongodb_url: {mongodb_url}")
    
def add_api_root(client, url=None, title=None, description=None, versions=None, max_content_length=0, default=False):
    if not versions:
        versions = ["application/taxii+json;version=2.1","application/taxii+json;version=2.0"]
    db = client["discovery_database"]
    url_parts = url.split("/")
    name = url_parts[-2]
    discovery_info = db["discovery_information"]
    info = discovery_info.find_one()
    info["api_roots"].append(name)
    discovery_info.update_one({"_id": info["_id"]}, {"$set": {"api_roots": info["api_roots"]}})
    api_root_info = db["api_root_info"]
    api_root_info.insert_one({
        "_url": url,
        "_name": name,
        "title": title,
        "description": description,
        "versions": versions,
        "max_content_length": max_content_length,
    })
    api_root_db = client[name]
    return api_root_db

def init_mongodb(url=None):
    if not url:
        url = mongodb_url 
    client = None
    print("Connecting to mongodb")
    for i in range(5):
        try:
            client = MongoClient(url, connectTimeoutMS=20000, timeoutMS=20000)
            if client:
                client.drop_database("discovery_database")
                break
        except Exception as exc:
            print(f"Retry {i + 1}...\nError: " + str(type(exc)) + " " + str(exc) + "")
    if not client:
        os._exit(1)
    print("Connected to mongodb")
    
    db = client["discovery_database"]
    db["discovery_information"].insert_one(
        {
            "title": "TAXII Server for sharing CTI",
            "description": "TAXII Server for sharing CTI between applications",
            "contact": "a@b.com",
            "default": f"{taxii_server_url}/{default_root_api_name}/",
            "api_roots":   [f"{taxii_server_url}/{x}/" for x in root_api_names],
        }
    )
    db["api_root_info"].insert_many(
        [
            {
                "title": "CTI TAXII Server",
                "description": "A CTI sharing group for application 1",
                "versions": [
                    "taxii-2.0",
                    "taxii-2.1",
                ],
                "max_content_length": 9765625,
                "_url": f"{taxii_server_url}/{x}/",
                "_name": f"{x}",
            }
            for x in root_api_names
        ]
    )
    for root_api_name in root_api_names:
        client.drop_database(root_api_name)
        api_root_db = add_api_root(
            client,
            url=f"{taxii_server_url}/{root_api_name}/",
            title="General STIX 2.1 Collections",
            description="A repo for general STIX data.",
            max_content_length=9765625,
        )
        api_root_db["information"].insert_one(
            {
                "title": f"STIX 2.1 Collections for {root_api_name}",
                "description": f"A repo for general STIX data produced by {root_api_name}.",
                "versions": ["application/taxii+json;version=2.1"],
                "max_content_length": 9765625,
            }
        )

        api_root_db["collections"].insert_many(
            [
                {
                    "id": collection_id,
                    "title": "App 1 CTI Vulnerability Collection",
                    "description": "This data collection contains high value IOCs",
                    "can_read": True,
                    "can_write": True,
                    "media_types": ["application/stix+json;version=2.1"],
                }
            ]
        )

if __name__ == "__main__":
    try:
        init_mongodb()
        print("successfully updated.")
        taxii_server_url = os.getenv("TAXII_SERVER_URL" , f"http://kubernetes.docker.internal:32222")
        print(f"taxii_server_url: {taxii_server_url}")
        print(f"collection_id: {collection_id}")
        print(f"default_root_api_name: {default_root_api_name}")
        print(f"root_api_names: {root_api_names_str}")
    except Exception as ex:
        print(str(ex))
