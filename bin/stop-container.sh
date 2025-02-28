#!/bin/bash

# Überprüfen, ob die NOTIFY_URL gesetzt ist
if [ -z "${NOTIFY_URL}" ]; then
    echo "Fehler: Die Umgebungsvariable NOTIFY_URL ist nicht gesetzt."
    exit 2
fi

# Wenn NOTIFY_URL das Wort "ping" enthält, sende einen Start-Request
if [[ "${NOTIFY_URL}" == *ping* ]]; then
    FULL_URL="${NOTIFY_URL}/start"
    response=$(curl --user-agent "resticker" -s -o /dev/null -w "%{http_code}" "${FULL_URL}")
    if [ "$response" -eq 200 ]; then
        echo "Start-Notification erfolgreich an ${FULL_URL} gesendet."
    else
        echo "Fehler beim Senden der Start-Notification. HTTP-Statuscode: $response"
        exit 3
    fi
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
