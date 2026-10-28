from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.templating import Jinja2Templates

from app.services.temperature import get_temperature
from app.services.shutdown import trigger_shutdown

app = FastAPI()
templates = Jinja2Templates(directory="app/templates")

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    temperature = get_temperature()
    return templates.TemplateResponse(
        request=request,
        name="index.html",
        context={"temperature": temperature},
    )

@app.get("/image")
async def image():
    return FileResponse("app/static/example.jpg")

@app.post("/shutdown")
async def shutdown():
    trigger_shutdown()
    return {"status": "ok"}
