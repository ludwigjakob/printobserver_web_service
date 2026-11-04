import json
from pathlib import Path


STATUS_FILE = Path(
    "/data/camera/status.json"
)


def get_camera_status():

    if not STATUS_FILE.exists():

        return {
            "status": "offline",
            "last_update": "never"
        }

    with open(
        STATUS_FILE,
        "r",
        encoding="utf-8"
    ) as file:

        return json.load(file)