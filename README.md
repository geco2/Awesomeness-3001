# Awesomeness-Portchecker-3001
Simple port/firewall tester in bash. Should be compatible with bash 4.x without any additional packages. Really helpful to check large amounts of firewall rules in closed environments.

* Destinations will be provided in CSV format.
* IPv4
* TCP and an experimantal UDP support
* bash 4.x

Inspired by https://github.com/tejado/Awesomeness-3000.git and https://www.commandlinefu.com/commands/view/24506/check-host-port-access-using-only-bash

## Examples
---
Create a file called ports.csv and put this in there:
```
10; Internet - google.net; www.google.net; 80; 443
```

Then go into your terminal and type:
```
portchecker.sh ports.csv
```
