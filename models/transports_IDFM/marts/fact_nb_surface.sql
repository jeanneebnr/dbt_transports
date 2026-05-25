{{ config(materialized='table') }}

WITH union_nb_surface AS (

    SELECT * FROM {{ ref('stg_nb_surface_2023_t1') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_nb_surface_2023_t2') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_nb_surface_2023_t3') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_nb_surface_2023_t4') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_nb_surface_2024_t1') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_nb_surface_2024_t2') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_nb_surface_2024_t3') }}
)

SELECT
    dl.id_ligne AS id_ligne,
    ns.date,
    dc.id_titre AS id_titre,
    ns.validations_nb


FROM union_nb_surface AS ns

LEFT JOIN {{ ref('dim_lignes') }} AS dl
    ON CONCAT(
    LPAD(CAST(SAFE_CAST(TRIM(ns.id_transporteur_stif) AS INT64) AS STRING), 3, '0'),
    LPAD(CAST(SAFE_CAST(TRIM(ns.id_reseau_stif) AS INT64) AS STRING), 3, '0'),
    LPAD(CAST(SAFE_CAST(TRIM(ns.id_ligne_stif) AS INT64) AS STRING), 3, '0')
) = dl.privatecode

LEFT JOIN {{ ref('dim_categorie_titres') }} AS dc
ON TRIM(ns.categorie_titre) = TRIM(dc.titre)