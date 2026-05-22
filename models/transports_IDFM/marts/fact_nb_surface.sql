{{ config(materialized='table') }}

WITH union_nb_surface AS (
    SELECT * FROM {{ source('idfm', 'nb_surface_2023_t1') }}
    UNION ALL
    SELECT * FROM {{ source('idfm', 'nb_surface_2023_t2') }}
    UNION ALL
    SELECT * FROM {{ source('idfm', 'nb_surface_2023_t3') }}
    UNION ALL
    SELECT * FROM {{ source('idfm', 'nb_surface_2023_t4') }}
    UNION ALL
    SELECT * FROM {{ source('idfm', 'nb_surface_2024_t1') }}
    UNION ALL
    SELECT * FROM {{ source('idfm', 'nb_surface_2024_t2') }}
    UNION ALL
    SELECT * FROM {{ source('idfm', 'nb_surface_2024_t3') }}
)

SELECT
    dl.id_ligne_stif                         AS id_ligne,
    PARSE_DATE('%d/%m/%Y', ns.jour)          AS date,
    dc.id_titre                              AS id_titre,
    ns.nb_vald                               AS nb_validation

FROM union_nb_surface AS ns

LEFT JOIN {{ ref('dim_lignes_stif') }} AS dl
    ON TRIM(ns.code_stif_ligne) = TRIM(dl.id_ligne_stif)

LEFT JOIN {{ ref('dim_categorie_titres') }} AS dc
    ON TRIM(ns.categorie_titre) = TRIM(dc.titre)