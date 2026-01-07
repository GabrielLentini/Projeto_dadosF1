from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import text

from app.db import get_db

router = APIRouter(prefix="/pilotos")

@router.get("/campeoes")
def pilotos_campeoes(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            nome_piloto,
            pontos_totais_carreira,
            titulos,
            vitorias,
            podios,
            pole_positions,
            largadas_top10,
            largadas_fora_top10,
            nacionalidade_piloto,
            data_nascimento_piloto
        FROM public.dim_pilotos
        WHERE titulos > 0
        ORDER BY titulos DESC, vitorias DESC
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }

@router.get("/vitoriosos")
def pilotos_vitoriosos(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            nome_piloto,
            pontos_totais_carreira,
            titulos,
            vitorias,
            podios,
            pole_positions,
            nacionalidade_piloto,
            data_nascimento_piloto
        FROM public.dim_pilotos
        WHERE vitorias > 0
        ORDER BY vitorias DESC, titulos DESC
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }

@router.get("/top20-podios")
def pilotos_top20_podios(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            nome_piloto,
            pontos_totais_carreira,
            titulos,
            vitorias,
            podios,
            pole_positions,
            nacionalidade_piloto,
            data_nascimento_piloto
        FROM public.dim_pilotos
        ORDER BY podios DESC, titulos DESC
        limit 20
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }

@router.get("/top20-pontos")
def pilotos_top20_pontos(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            nome_piloto,
            pontos_totais_carreira,
            titulos,
            vitorias,
            podios,
            pole_positions,
            nacionalidade_piloto,
            data_nascimento_piloto
        FROM public.dim_pilotos
        ORDER BY pontos_totais_carreira DESC, titulos DESC
        limit 20
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }

@router.get("/top20-poles")
def pilotos_top20_poles(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            nome_piloto,
            pontos_totais_carreira,
            titulos,
            vitorias,
            podios,
            pole_positions,
            nacionalidade_piloto,
            data_nascimento_piloto
        FROM public.dim_pilotos
        ORDER BY pole_positions DESC, titulos DESC
        limit 20
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }

@router.get("/brasileiros")
def pilotos_brasileiros(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            nome_piloto,
            pontos_totais_carreira,
            titulos,
            vitorias,
            podios,
            pole_positions,
            largadas_top10,
            largadas_fora_top10,
            nacionalidade_piloto,
            data_nascimento_piloto
        FROM public.dim_pilotos
        WHERE nacionalidade_piloto = 'BRAZILIAN'
        ORDER BY titulos DESC,pontos_totais_carreira DESC
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }