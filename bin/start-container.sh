#!/bin/bash

# Liste der IDs der Docker-Container abrufen, die das Label 'backups=true' haben
containers=$(docker ps -qa -f 'label=backups=true')

if [ -z "$containers" ]; then
    # Wenn keine Container mit dem Label gefunden wurden
    echo "Keine Docker-Container mit dem Label 'backups=true' gefunden."
else
    # Wenn Container mit dem Label gefunden wurden, diese starten
    docker start $containers
    if [ $? -eq 0 ]; then
        echo "Docker-Container erfolgreich gestartet."
    else
        echo "Fehler: Docker-Container konnten nicht gestartet werden."
        /scripts/report-status.sh down
        exit 1
    fi
fi

# Restic unlock-Befehl ausführen
echo "Führe 'restic unlock' aus..."
restic unlock
if [ $? -ne 0 ]; then
    echo "Fehler: 'restic unlock' fehlgeschlagen."
    /scripts/report-status.sh down
    exit 1
else
    echo "'restic unlock' erfolgreich ausgeführt."
fi

exit 0
