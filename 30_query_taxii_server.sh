curl -u 'medallion_admin:Test.1234' -H "Accept: application/taxii+json;version=2.1"  'http://kubernetes.docker.internal:32222/app1/collections/vulnerabilities/objects/?match%5Btype%5D=vulnerability&added_after=2024-07-28T07:00:34.12345Z'