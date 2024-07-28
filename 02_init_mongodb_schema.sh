# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
MONGO_DB_SERVICE_HOST="kubernetes.docker.internal"
MONGO_DB_SERVICE_PORT=32517
MONGO_DB_USERNAME="mongodb_admin"
MONGO_DB_USER_PASSWORD="Test.123456"
MONGO_DB_AUTH_DATABASE="admin"
export TAXII_SERVER_URL="http://kubernetes.docker.internal:32222"
###############################################################################

export COLLECTION_ID="vulnerabilities"
export DEFAULT_ROOT_API_NAME="app1"
export ROOT_API_NAMES="app1,app2"

export MONGODB_URL="mongodb://${MONGO_DB_USERNAME}:${MONGO_DB_USER_PASSWORD}@${MONGO_DB_SERVICE_HOST}:${MONGO_DB_SERVICE_PORT}/?authSource=${MONGO_DB_AUTH_DATABASE}"

export PYTHONPATH=$(pwd)
python3 init_mongodb_schema.py