#!/bin/bash

NAME="printobserver_web_service"
PORT="8000"

echo "🔍 Stoppe und lösche alten Container (falls vorhanden)..."
docker rm -f $NAME 2>/dev/null

echo "🔨 Baue neues Docker-Image..."
docker build -t $NAME .

if [ $? -ne 0 ]; then
    echo "❌ Build fehlgeschlagen!"
    exit 1
fi

echo "🚀 Starte neuen Container..."
docker run -d --name $NAME -p $PORT:$PORT $NAME

if [ $? -ne 0 ]; then
    echo "❌ Container konnte nicht gestartet werden!"
    exit 1
fi

echo "📜 Zeige Logs an..."
docker logs -f $NAME
