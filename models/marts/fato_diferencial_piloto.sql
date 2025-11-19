{{ config(
    unique_key='id_fato_diferencial_piloto',
    materialized='table',
    tags=['estatisticas']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'MAX(dim_e.id_dim_estatisticas)',
        'MAX(int_pt.id_piloto)'
    ]) }} AS id_fato_diferencial_piloto,
    MAX(dim_e.id_dim_estatisticas) AS id_dim_estatisticas,
    MAX(int_pt.id_piloto) AS id_piloto,
    int_pt.numero_paradas,
    int_pt.ano
FROM {{ ref('int_pit_stops') }} AS int_pt
LEFT JOIN {{ ref('dim_estatisticas') }} AS dim_e
    ON int_pt.id_piloto = dim_e.id_piloto
GROUP BY int_pt.numero_paradas, int_pt.ano
