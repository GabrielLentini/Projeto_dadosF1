{{ config(
    unique_key='id_estatisticas',
    materialized='table',
    tags=['status', 'estatisticas']
) }}

--noqa:disable=LT05, CV11
SELECT
    {{ dbt_utils.generate_surrogate_key(['pc.id_piloto', 'pt.numero_paradas', 'pc.ano']) }} AS id_estatisticas,
    pc.id_piloto,
    st.ano,
    pt.numero_paradas,
    st.status_piloto_ano,
    pc.colocacao_no_campeonato
FROM {{ ref('int_posicao_campeonato') }} AS pc
LEFT JOIN {{ ref('int_status') }} AS st
    ON
        pc.id_piloto = st.id_piloto
        AND pc.ano = st.ano
LEFT JOIN {{ ref('int_pit_stops') }} AS pt
    ON
        pt.id_piloto = pc.id_piloto
        AND pt.ano = pc.ano
