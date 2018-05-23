# mps-microservice
This is a container ready MPS service

## Preparing the service

Install required Javascript modules
```shell
npm install
```

## Creating config.json in folder _private_

Here is an example of config.json
```json
{
    "usewhitelist" : "true",
    "commonName": "yourhost.tld",
    "mpsport": 4433,
    "mpsusername": "standalone",
    "mpspass": "P@ssw0rd",
    "country": "US",
    "company": "NoCorp",
    "debug": true
}
```

## _(Optional)_ Create mockup credentials.json and guids.json

The two files are to simulate credential storages and GUID for whitelisting.

*Warning: these files are for development only, real deployment must use secure credentials and GUID whitelist storage*

### credential.json
```json
{
    "8dad96cb-c3db-11e6-9c43-bc0000d20000": {
        "name" : "Win7-machine",
        "mpsuser": "standalone",
        "mpspass": "P@ssw0rd",
        "amtuser": "admin",
        "amtpass": "P@ssw0rd"
    },
    "bf49cf00-9164-11e4-952b-b8aeed7ec594" : {
        "name" : "Ubuntu-machine",
        "mpsuser": "xenial",
        "mpspass": "P@ssw0rd",
        "amtuser": "admin",
        "amtpass": "P@ssw0rd"
    }
}
```

### guids.json
```json
["8dad96cb-c3db-11e6-9c43-bc0000d20000","12345678-9abc-def1-2345-123456789000", "12345678-9abc-def1-2345-123456789001"]
```
## TODO
* REST API to update credentials
* UI Components for AMT KVM and Terminal.