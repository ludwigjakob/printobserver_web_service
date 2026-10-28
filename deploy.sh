#!/bin/bash

NAME="printobserver_web_service"
PORT="8000"

echo "🔍 Entferne alten Container..."
docker rm -f $NAME 2>/dev/null

echo "🔨 Baue neues Docker-Image..."
docker build -t $NAME .

if [ $? -ne 0 ]; then
    echo "❌ Build fehlgeschlagen!"
    exit 1
fi

echo "🚀 Starte neuen Container..."
docker run -d --restart=always --name $NAME -p $PORT:$PORT $NAME

if [ $? -ne 0 ]; then
    echo "❌ Container konnte nicht gestartet werden!"
    exit 1
fi

echo "📜 Logs:"
docker logs -f $NAME
