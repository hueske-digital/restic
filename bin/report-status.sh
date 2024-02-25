#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Fehler: Kein Status (UP oder DOWN) als Parameter übergeben."
    exit 1
fi

STATUS=$1

if [ -z "${NOTIFY_URL}" ]; then
    echo "Fehler: Die Umgebungsvariable NOTIFY_URL ist nicht gesetzt."
    exit 2
fi

FULL_URL="${NOTIFY_URL}?status=${STATUS}"

response=$(curl -s -o /dev/null -w "%{http_code}" "${FULL_URL}")

if [ "$response" -eq 200 ]; then
    echo "Erfolgreich an die Monitoring-API gesendet."
else
    echo "Fehler beim Senden an die Monitoring-API. HTTP-Statuscode: $response"
    exit 3
fi

exit 0
