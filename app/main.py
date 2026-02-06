import os
from fastapi import FastAPI
from fastapi.responses import JSONResponse

APP_NAME = os.getenv("APP_NAME", "hello-ms")
APP_VERSION = os.getenv("APP_VERSION", "0.1.0")

app = FastAPI(title=APP_NAME, version=APP_VERSION)

@app.get("/")
def root():
    return {
        "message": "Hello World",
        "service": APP_NAME,
        "version": APP_VERSION,
    }

@app.get("/health")
def health():
    # liveness: processo está vivo
    return JSONResponse(content={"status": "ok"}, status_code=200)

@app.get("/ready")
def ready():
    # readiness: pronto pra receber tráfego
    return JSONResponse(content={"status": "ready"}, status_code=200)

@app.get("/version")
def version():
    return {"service": APP_NAME, "version": APP_VERSION}
