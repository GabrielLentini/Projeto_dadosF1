import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv

# Required env vars:
# DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD

# Carrega variáveis do .env
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL not set in .env file")

# Engine = conexão com o banco
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,  # evita conexões mortas
)

# Sessão para executar queries
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)

# Dependency do FastAPI
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
