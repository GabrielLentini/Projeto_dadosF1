from fastapi import FastAPI
from app.routers import health, db_check, pilotos, equipes, corridas

app = FastAPI(title="F1 Data API")

app.include_router(
    health.router,
    prefix="/api/v1",
    tags=["health"],
)

app.include_router(
    db_check.router,
    prefix="/api/v1",
    tags=["database"],
)

app.include_router(
    pilotos.router,
    prefix="/api/v1",
    tags=["pilotos"],
)

app.include_router(
    equipes.router,
    prefix="/api/v1",
    tags=["equipes"],
)

app.include_router(
    corridas.router,
    prefix="/api/v1",
    tags=["corridas"],
)
