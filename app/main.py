from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.templating import Jinja2Templates

from app.services.temperature import get_temperature
from app.services.shutdown import trigger_shutdown
from app.services.status import get_camera_status

app = FastAPI()
templates = Jinja2Templates(directory="app/templates")

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    temperature = get_temperature()
    camera_status = get_camera_status()
    return templates.TemplateResponse(
        request=request,
        name="index.html",
        context={
            "request": request,
            "temperature": temperature,
            "camera_status": camera_status
        }
    )

@app.get("/image")
async def image():
    return FileResponse("/data/camera/latest/latest.jpg")

@app.post("/shutdown")
async def shutdown():
    trigger_shutdown()
    return {"status": "ok"}
