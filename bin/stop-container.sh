#!/bin/bash

# Restic unlock ausführen
restic unlock
if [ $? -ne 0 ]; then
    echo "Fehler: Restic Unlock konnte nicht ausgeführt werden."
    /scripts/report-status.sh down
    exit 1  # Skript abbrechen, wenn restic unlock fehlschlägt
else
    echo "Restic Unlock erfolgreich."
fi

# Liste der IDs der Docker-Container abrufen, die das Label 'backups=true' haben
containers=$(docker ps -qa -f 'label=backups=true')

if [ -z "$containers" ]; then
    # Wenn keine Container mit dem Label gefunden wurden
    echo "Keine Docker-Container mit dem Label 'backups=true' gefunden."
else
    # Wenn Container mit dem Label gefunden wurden, diese stoppen
    docker stop $containers
    if [ $? -eq 0 ]; then
        echo "Docker-Container erfolgreich gestoppt."
    else
        echo "Fehler: Docker-Container konnten nicht gestoppt werden."
        /scripts/report-status.sh down
        exit 1
    fi
fi

exit 0
