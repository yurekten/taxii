# TAXI Client prototype

## Create virtual environment
```
bash _setup_venv.sh
```

## deploy TAXII 2.1 clients and server in k8s namespaces

Namespaces are app1, app2 and cti.
```
Namespace     Component     Service Name            Ports
app1          app1-client   -                       -
app1          app1-proxy    app1-proxy-service      8080:32233/TCP
app2          app2-client   -                       -
app2          app2-proxy    app2-proxy-service      8080:32244/TCP
cti           mongodb       mongodb-service         27017:32517/TCP
cti           taxii-server  taxii-server-service    80:32222/TCP
```

Deployment diagram

```
                                               [cti Namespace]
                    app1-client <------------                   ------------> app2-client
[app1 Namespace]                                taxii-server                                [app2 Namespace]
                    app1-proxy  ------------>       |           <------------ app2-proxy
                                                    |
                                                    v
                                                 mongodb
```

### TAXII clients and kubernetes scripts

Before run scripts, review all bash scripts start with 0[1-9]_*.sh and update configuration parameters

```
bash 20_delete_all.sh
bash 00_setup_all.sh

```

Monitor App 1 client (listens App 2 vulnerabilities on Taxii server)
```
bash 10_monitor_cti_in_app1_client.sh

```

Monitor App 2 client (listens App 1 vulnerabilities on Taxii server)
```
bash 11_monitor_cti_in_app2_client.sh

```

Monitor App 1 proxy (publish vulnerabilities of App 1)
```
bash 12_monitor_app1_taxii_proxy.sh

```

Monitor App 2 proxy (publish vulnerabilities of App 2)
```
bash 13_monitor_app2_taxii_proxy.sh

```

Monitor Taxii server logs
```
bash 14_monitor_taxii_server.sh

```