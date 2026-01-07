from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import text

from app.db import get_db

router = APIRouter(prefix="/corridas")

@router.get("/2024")
def corridas_2024(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            ano_corrida,
            nome_circuito,
            data_corrida,
            voltas_concluidas,
            tempo_volta_mais_rapida,
            primeiro_colocado,
            segundo_colocado,
            terceiro_colocado,
            piloto_pole_position
        FROM public.dim_corridas
        WHERE ano_corrida = 2024
        ORDER BY data_corrida ASC
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }

@router.get("/brasil")
def corridas_brasil(db: Session = Depends(get_db)):
    query = text("""
        SELECT
            ano_corrida,
            nome_circuito,
            data_corrida,
            voltas_concluidas,
            tempo_volta_mais_rapida,
            primeiro_colocado,
            segundo_colocado,
            terceiro_colocado,
            piloto_pole_position
        FROM public.dim_corridas
        WHERE nome_circuito IN('SAO PAULO GRAND PRIX', 'BRAZILIAN GRAND PRIX')
        ORDER BY data_corrida ASC
    """)

    result = db.execute(query).mappings().all()

    return {
        "total": len(result),
        "items": result
    }