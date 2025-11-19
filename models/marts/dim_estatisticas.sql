{{ config(
    unique_key='id_estatisticas',
    materialized='table',
    tags=['status', 'estatisticas']
) }}

--noqa:disable=LT05, CV11
SELECT
    {{ dbt_utils.generate_surrogate_key(['pc.id_piloto', 'pt.numero_paradas', 'pc.ano_campeonato']) }} AS id_dim_estatisticas,
    pc.id_piloto,
    pc.ano_campeonato AS ano,
    COALESCE(pt.numero_paradas::text, '(N/A)') AS numero_paradas,
    pt.numero_paradas AS numero_paradas_int,
    st.status_piloto_ano,
    pc.colocacao_no_campeonato
FROM {{ ref('int_posicao_campeonato') }} AS pc
LEFT JOIN {{ ref('int_status') }} AS st
    ON
        pc.id_piloto = st.id_piloto
        AND pc.ano_campeonato = st.ano_corrida
LEFT JOIN {{ ref('int_pit_stops') }} AS pt
    ON
        pt.id_piloto = pc.id_piloto
        AND pt.ano = pc.ano_campeonato
