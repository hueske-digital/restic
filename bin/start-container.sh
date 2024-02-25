#!/bin/bash

docker start $(docker ps -qa -f 'label=backups=true')

if [ $? -eq 0 ]; then
    echo "Docker-Container erfolgreich gestartet."
else
    echo "Fehler: Docker-Container konnten nicht gestartet werden."
    /scripts/report-status.sh down
    exit 1
fi

exit 0