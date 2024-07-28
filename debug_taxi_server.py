
from medallion import load_app

config_file = "debug_taxii_config.json"
application_instance = load_app(config_file)
application_instance.run(
    host="0.0.0.0",
    port=9999,
    debug=True
)
