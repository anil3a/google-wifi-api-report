# Google Wifi API

I created this script to get all devices connected to my Google WiFi router from a url that Google made available to us.
This script logs Google WiFi Diagnostic Report and stores active ( or with defined name ) device into spreadsheet Format ( CSV )


TODO: 

1. HEADER
station_id,last_seen_seconds_since_epoch,wireless_interface,dhcp_hostname,oui,ip_addresses,mdns_name,connected

2. Read me
Write proper Read me i guess

3. Write proper loop


**Usage**

```
./anl_google_wifi_api.sh
```
**Dependency**

1. [httpie](https://httpie.org)

**Tested**

Works in Linux ( Only tested in Ubuntu 18.0.1 )



---

### Copyrights and licence

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.

"Google", "Google Wifi" and "OnHub" are properties and trademarks of Google LLC. ©2019 Google LLC. Google and the Google Logo are registered trademarks of Google LLC.

© 2019 [Anil Prajapati](https://anil3a.github.io/).
