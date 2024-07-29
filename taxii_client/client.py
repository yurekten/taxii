

import datetime
import os
import time
from pathlib import Path

from stix2 import Filter, TAXIICollectionSource
from taxii2client.v21 import Server, as_pages

from taxii_client import taxii_utils


def check_collection_objects(server, api_root_name, collection_id):

    api_root = taxii_utils.get_api_root_name_from_server(server, api_root_name)
    collection = taxii_utils.get_api_root_name_from_api_root(api_root, collection_id)
    

    if collection:
        #####
        ## LOGIC
        ####
        
        # - Example 1: filter source with stix 
        taxii_source =  TAXIICollectionSource(collection)
        data = taxii_source.query(Filter('modified', '>', '2023-11-07T03:02:21.000Z'))
        for item in data:
            print(item)
        
        # - Example 2: get manifest to find vulnerabilities with date_added 
        for envelope in as_pages(collection.get_manifest, per_request=50):
            if not envelope:
                print(f"No manifest data in  {api_root_name}/collections/{collection_id}")
                break
            manifest_resources = envelope["objects"]
            if manifest_resources:
                for resource in manifest_resources:
                    print(resource)
                    date_added = resource["date_added"]
                    id = resource["id"]
                    version = resource["version"]
                    media_type = resource["media_type"]
                    print(f"Date added: {date_added}")
                    print(f"id: {id}")
                    cti_item = collection.get_object(id)
                    
                    print(cti_item)

        return envelope
    return []

if __name__ == "__main__":
    taxii_server_url = os.getenv("TAXII_SERVER_URL", "http://kubernetes.docker.internal:32222")
    collection_id = os.getenv("COLLECTION_ID", "vulnerabilities")
    api_root_name = os.getenv("API_ROOT_NAME", "app2")
    medallion_username = os.getenv("MEDALLION_USERNAME", "medallion_admin")
    medallion_user_password = os.getenv("MEDALLION_USER_PASSWORD", "Test.1234")
    pool_period_in_second_str = os.getenv("POOL_PERIOD_IN_SECONDS", "30")
    print("Starting server")
    print(f"taxii_server_url: {taxii_server_url}")
    print(f"collection_id: {collection_id}")
    print(f"api_root_name: {api_root_name}")
    print(f"medallion_username: {medallion_username}")
    try:
        pool_period_in_second = int(pool_period_in_second_str)
    except:
        pool_period_in_second = 30
        print("Invalid POOL_PERIOD_IN_SECONDS parameter, pool period is 30 seconds now.")
    try:
        while True:
            try:
                server = Server(f'{taxii_server_url}/taxii2/', user=medallion_username, password=medallion_user_password)
                print(server.title)
                now_str = datetime.datetime.now(datetime.timezone.utc).isoformat()
                print(f"Check api {api_root_name}, collection {collection_id}: {now_str}")
                check_collection_objects(server, api_root_name, collection_id)
            except Exception as exc:
                print("Error" + str(type(exc)) +  " " + str(exc))
            now_str = datetime.datetime.now(datetime.timezone.utc).isoformat()
            Path("/tmp/healthy").write_text(now_str)
            time.sleep(pool_period_in_second)
    except Exception as ex:
        print(str(ex))
        f = Path("/tmp/healthy")
        if f.exists() and f.is_file():
            os.remove(str(f))