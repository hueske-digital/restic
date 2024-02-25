#!/bin/bash

docker stop $(docker ps -qa -f 'label=backups=true')

if [ $? -eq 0 ]; then
    echo "Docker-Container erfolgreich gestoppt."
else
    echo "Fehler: Docker-Container konnten nicht gestoppt werden."
    exit 1
fi

exit 0
