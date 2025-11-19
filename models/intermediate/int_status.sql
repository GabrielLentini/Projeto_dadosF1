{{ config(
    unique_key='id_status',
    materialized='table',
    tags=['status']
) }}

SELECT
    r.id_piloto,
    c.ano_corrida,
    jsonb_build_object(
        'status no ano:',
        jsonb_agg(DISTINCT jsonb_build_object(
            'id_corrida', c.id_corrida,
            'id_status', st.id_status,
            'status', st.status
        ))
    ) AS status_piloto_ano
FROM {{ ref('stg_status') }} AS st
LEFT JOIN {{ ref('stg_resultados') }} AS r
    ON r.id_status = st.id_status
LEFT JOIN {{ ref('stg_corridas') }} AS c
    ON c.id_corrida = r.id_corrida
GROUP BY c.ano_corrida, r.id_piloto
