from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import text

from app.db import get_db

router = APIRouter(prefix="/equipes")

@router.get("")
def lista_equipes(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            nome_equipe,
            pontos_totais_equipe,
            titulos,
            vitorias,
            podios,
            pole_positions,
            largadas_top10,
            largadas_fora_top10,
            nacionalidade_equipe,
            pilotos_da_equipe
        FROM public.dim_equipes
        ORDER BY titulos DESC, vitorias DESC
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }

@router.get("/campeas")
def equipes_campeas(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            nome_equipe,
            pontos_totais_equipe,
            titulos,
            vitorias,
            podios,
            pole_positions,
            nacionalidade_equipe
        FROM public.dim_equipes
        WHERE titulos > 0
        ORDER BY titulos DESC, vitorias DESC
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }

@router.get("/top20-vitorias")
def equipes_top20_vitorias(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            nome_equipe,
            pontos_totais_equipe,
            titulos,
            vitorias,
            podios,
            pole_positions,
            nacionalidade_equipe
        FROM public.dim_equipes
        ORDER BY vitorias DESC, titulos DESC
        LIMIT 20
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }