#!/bin/bash

NAME="printobserver_web_service"
PORT="8000"
SERVICE_FILE="/etc/systemd/system/printobserver.service"

echo "📦 Installiere Docker..."
curl -fsSL https://get.docker.com | sudo sh

echo "👤 Füge aktuellen Benutzer der Docker-Gruppe hinzu..."
sudo usermod -aG docker $USER

echo "🔍 Entferne alten Container (falls vorhanden)..."
docker rm -f $NAME 2>/dev/null

echo "🧹 Entferne altes Image (falls vorhanden)..."
docker rmi $NAME 2>/dev/null

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

echo "📝 Erstelle systemd-Service-Datei..."
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=PrintObserver Web Service
After=network.target docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a $NAME
ExecStop=/usr/bin/docker stop -t 2 $NAME

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 Lade systemd neu..."
sudo systemctl daemon-reload

echo "📌 Aktiviere Autostart..."
sudo systemctl enable printobserver.service

echo "▶️ Starte Service..."
sudo systemctl start printobserver.service

echo "📜 Zeige Logs:"
docker logs -f $NAME
