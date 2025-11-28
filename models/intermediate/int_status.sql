{{ config(
    unique_key='id_status',
    materialized='table',
    tags=['status']
) }}

SELECT
    res.id_piloto,
    cor.ano_corrida AS ano,
    jsonb_build_object(
        'status no ano:',
        jsonb_agg(DISTINCT jsonb_build_object(
            'id_corrida', cor.id_corrida,
            'id_status', st.id_status,
            'status', st.status
        ))
    ) AS status_piloto_ano
FROM {{ ref('stg_status') }} AS st
LEFT JOIN {{ ref('stg_resultados') }} AS res
    ON res.id_status = st.id_status
LEFT JOIN {{ ref('stg_corridas') }} AS cor
    ON cor.id_corrida = res.id_corrida
GROUP BY cor.ano_corrida, res.id_piloto
