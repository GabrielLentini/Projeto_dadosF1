{{ config(
    unique_key='id_equipe',
    materialized='table',
    tags=['construtores']
) }}

--noqa:disable=LT01
WITH titulos_oficiais AS (
    SELECT *
    FROM (
        VALUES
        ('MCLAREN',          9),
        ('VANWALL',          1),
        ('MERCEDES',         8),
        ('COOPER-CLIMAX',    2),
        ('LOTUS-CLIMAX',     2),
        ('LOTUS-FORD',       1),
        ('BRABHAM-REPCO',    2),
        ('MATRA-FORD',       1),
        ('BENETTON',         1),
        ('BRAWN',            1),
        ('TYRRELL',          1),
        ('WILLIAMS',         9),
        ('TEAM LOTUS',       4),
        ('RENAULT',          2),
        ('FERRARI',         16),
        ('BRM',              1),
        ('RED BULL',         6)
    ) AS t(nome_equipe_oficial, titulos)
)

SELECT
    con.id_equipe,
    tit.titulos
FROM titulos_oficiais AS tit
LEFT JOIN {{ ref('stg_construtores') }} AS con
    ON con.nome_equipe = tit.nome_equipe_oficial
