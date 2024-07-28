
# REVIREW and UPDATE ENVIRONMENT and CONFIGURATION
###############################################################################
APP2_TAXII_PROXY_HOST="http://kubernetes.docker.internal"
APP2_TAXII_PROXY_PORT="32244"
# ACCESS TOKENS are stored in auth.json
APP2_TAXII_PROXY_ACCESS_TOKEN="ba3069e9-d45d-4b28-add7-bd63f3e3d0b8"
###############################################################################

curl -X POST -H "X-Access-Token: $APP2_TAXII_PROXY_ACCESS_TOKEN" -H "Content-Type: application/json" $APP2_TAXII_PROXY_HOST:$APP2_TAXII_PROXY_PORT/vulnerabilities --data '{"fixedVersion": "2.4.25-3+deb9u8","installedVersion": "2.4.25-3+deb9u5","lastModifiedDate": "2023-11-07T03:02:22Z","primaryLink": "https://avd.aquasec.com/nvd/cve-2019-10082","publishedDate": "2019-09-26T16:15:10Z","resource": "apache2","score": 9.1,"severity": "CRITICAL","title": "httpd: read-after-free in h2 connection shutdown","vulnerabilityID": "CVE-2019-10082"}'