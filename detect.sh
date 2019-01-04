 #!/bin/bash
# Program name: pingall.sh
date
cat list.txt |  while read output
do
#    curl http://192.168.1.101:5000/webman/index.html > index.html
    curl --max-time 15  --connect-timeout 15 "http://$output:5000/index.html" > index.html
    var=$(grep synology index.html)
    if [[ $var =~ synology ]]
    then
        echo "synology detected"
        echo "$output" >> synology.txt
    else
        echo "other system detected"
    fi

done
