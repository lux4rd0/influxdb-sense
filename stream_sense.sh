#!/bin/bash

/usr/bin/timeout 10m /websocat -k -n wss://clientrt.sense.com/monitors/${ID}/realtimefeed \
-H "Authorization: bearer ${TOKEN}" \
-H "Sense-Client-Version: 1.17.1-20c25f9" -H "X-Sense-Protocol: 3" -H "User-Agent: okhttp/3.8.0" | /influxdb_sense.sh
