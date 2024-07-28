
from typing import Union

from taxii2client.v21 import ApiRoot, Collection


def get_api_root_name_from_server(server, api_root_name) -> Union[None, ApiRoot]:
    api_root = None
    for item in server.api_roots:
        parts = item.url.split('/') 
        if parts and len(parts) > 0:
            item_api_root = parts[-2]
            if item_api_root == api_root_name:
                api_root = item
                break
    return api_root

def get_api_root_name_from_api_root(api_root, collection_id) -> Union[None, Collection]:
    collection = None
    if api_root:
        for item in api_root.collections:
            if item.id == collection_id:
                collection = item
                break
    return collection