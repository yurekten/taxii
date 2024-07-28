# deploy mongo db, default nodeport 32517
bash 01_setup_mongo.sh

# wait until mongo is up and create schema
bash 02_init_mongodb_schema.sh

# deploy taxii server, default nodeport 32222
bash 03_setup_taxii_server.sh

# deploy taxii proxy in app1, default nodeport 32233
bash 04_setup_app1_taxii_proxy.sh

bash 05_setup_app1_taxii_clie.sh

# deploy taxii proxy in app2, default nodeport 32244
bash 06_setup_app2_taxii_proxy.sh

bash 07_setup_app2_taxii_client.sh

bash 08_create_a_cti_in_app1.sh