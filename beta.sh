#!/bin/bash
[[ -z "$1" ]] && { echo "Parameter 1 is empty - ip address : 192.168.1.1:5000 " ; exit 1; }
echo "-----------"
echo "test for " $1
echo "-----------"
# User defined vars
syno_user="admin"
syno_pwd="admin"
syno_url=$1 # eg 192.168.1.100:5000
vAuth=2
# Get Paths (recommended by Synology for further update)
curlResult=$(curl -s "http://${syno_url}:5000/webapi/query.cgi?api=SYNO.API.Info&method=Query&version=1&query=SYNO.API.Auth,SYNO.SurveillanceStation.Camera")
authPath=$(echo "$curlResult" | jq -r '.["data"]["SYNO.API.Auth"]["path"]')
# Do login
curlResult=$(curl -s "http://${syno_url}:5000/webapi/${authPath}?api=SYNO.API.Auth&method=Login&version=${vAuth}&account=${syno_user}&passwd=${syno_pwd}&session=SurveillanceStation&format=sid")
if [[ $(echo "$curlResult" | jq -r '.["success"]') == 'false' ]]; then
        echo "$1 login is down" >> dwn.txt
        echo "Error on login"
        exit 0
fi
echo "succes login for $syno_url"
echo "$1 login is admin admin" >> up.txt


# Do logoff
curl -s "http://${syno_url}:5000/webapi/${authPath}?api=SYNO.API.Auth&method=Logout&version=${vAuth}&_sid=${SID}" > /dev/null 2>&1
