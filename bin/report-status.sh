#!/bin/bash

# Standardmäßig "DOWN", wenn kein Parameter oder ein ungültiger Wert übergeben wird.
if [ $# -eq 0 ]; then
    STATUS="DOWN"
else
    STATUS=$(echo "$1" | tr '[:lower:]' '[:upper:]') # Konvertiere in Großbuchstaben
    if [[ ! "$STATUS" =~ ^(UP|DOWN)$ ]]; then
        echo "Ungültiger Status übergeben. Standardmäßig 'DOWN' verwenden."
        STATUS="DOWN"
    fi
fi

# Überprüfen, ob die NOTIFY_URL gesetzt ist.
if [ -z "${NOTIFY_URL}" ]; then
    echo "Fehler: Die Umgebungsvariable NOTIFY_URL ist nicht gesetzt."
    exit 2
fi

# Anpassen der URL je nach Bedingungen.
if [ "$STATUS" == "DOWN" ] && [[ "${NOTIFY_URL}" == *ping* ]]; then
    FULL_URL="${NOTIFY_URL}/fail"
else
    FULL_URL="${NOTIFY_URL}?status=${STATUS}"
fi

# Senden der Anfrage und Überprüfung des Ergebnisses.
response=$(curl -s -o /dev/null -w "%{http_code}" "${FULL_URL}")

if [ "$response" -eq 200 ]; then
    echo "Erfolgreich an die Monitoring-API gesendet."
else
    echo "Fehler beim Senden an die Monitoring-API. HTTP-Statuscode: $response"
    exit 3
fi

exit 0
