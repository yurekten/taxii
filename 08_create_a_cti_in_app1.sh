
# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
APP1_TAXII_PROXY_HOST="http://kubernetes.docker.internal"
APP1_TAXII_PROXY_PORT="32233"
# ACCESS TOKENS are stored in auth.json
APP1_TAXII_PROXY_ACCESS_TOKEN="6df17720-c569-4c26-92d7-6cfb5c7398c2"
###############################################################################

curl -X POST -H "X-Access-Token: $APP1_TAXII_PROXY_ACCESS_TOKEN" -H "Content-Type: application/json" $APP1_TAXII_PROXY_HOST:$APP1_TAXII_PROXY_PORT/vulnerabilities --data '{"fixedVersion": "2.4.25-3+deb9u8","installedVersion": "2.4.25-3+deb9u5","lastModifiedDate": "2023-11-07T03:02:22Z","primaryLink": "https://avd.aquasec.com/nvd/cve-2019-10082","publishedDate": "2019-09-26T16:15:10Z","resource": "apache2","score": 9.1,"severity": "CRITICAL","title": "httpd: read-after-free in h2 connection shutdown","vulnerabilityID": "CVE-2019-10082"}'