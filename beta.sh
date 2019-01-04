#!/bin/bash

# PARAMS
# 1 : enable | disable | check
# 2 : ID(s) of camera(s), if more than one (Only for enable and disable actions) : coma separed (eg : 1,4)
# 3 : IDx of domoticz dummy switch

# No idx given = stop script
[[ -z "$1" ]] && { echo "Parameter 1 is empty - ip address : 192.168.1.1:5000 " ; exit 1; }
 #[[ -z "$2" ]] && { echo "Parameter 2 is empty" ; exit 1; }
#[[ -z "$3" ]] && { echo "Parameter 3 is empty" ; exit 1; }
echo "-----------"
echo "test for " $1
echo "-----------"
# User defined vars
syno_user="admin"
syno_pwd="admin"
syno_url=$1 # eg 192.168.1.100:5000
#syno_url="192.168.1.101:5000" # eg 192.168.1.100:5000
#domoticz_url="127.0.0.1:8080" # eg 127.0.0.1:8080
vAuth=2
#vCam=8
#vList=1


# Get Paths (recommended by Synology for further update)
curlResult=$(curl -s "http://${syno_url}:5000/webapi/query.cgi?api=SYNO.API.Info&method=Query&version=1&query=SYNO.API.Auth,SYNO.SurveillanceStation.Camera")
authPath=$(echo "$curlResult" | jq -r '.["data"]["SYNO.API.Auth"]["path"]')
#surveillancePath=$(echo "$curlResult" | jq -r '.["data"]["SYNO.SurveillanceStation.Camera"]["path"]')

# Do login
curlResult=$(curl -s "http://${syno_url}:5000/webapi/${authPath}?api=SYNO.API.Auth&method=Login&version=${vAuth}&account=${syno_user}&passwd=${syno_pwd}&session=SurveillanceStation&format=sid")
if [[ $(echo "$curlResult" | jq -r '.["success"]') == 'false' ]]; then
        echo "$1 login is down" >> dwn.txt
        echo "Error on login"
        exit 0
fi
# Storage of SID for further actions
echo "succes login for $syno_url"
echo "$1 login is admin admin" >> up.txt
SID=$(echo "$curlResult" | jq -r '.["data"]["sid"]')

# Do logoff
curl -s "http://${syno_url}:5000/webapi/${authPath}?api=SYNO.API.Auth&method=Logout&version=${vAuth}&_sid=${SID}" > /dev/null 2>&1
