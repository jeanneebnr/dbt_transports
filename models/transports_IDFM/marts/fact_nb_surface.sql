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
    dl.id_ligne,
    dl.privatecode,
    PARSE_DATE('%d/%m/%Y', ns.jour) AS date,
    dc.id_titre AS id_titre,
    ns.nb_vald AS nb_validation

FROM union_nb_surface AS ns

LEFT JOIN {{ ref('dim_lignes') }} AS dl
ON CONCAT(
    TRIM(CAST(ns.id_transporteur_stif AS STRING)),
    TRIM(CAST(ns.code_stif_ligne AS STRING)),
    TRIM(CAST(ns.id_reseau AS STRING))
) = TRIM(dl.privatecode)

LEFT JOIN {{ ref('dim_categorie_titres') }} AS dc
ON TRIM(ns.categorie_titre) = TRIM(dc.titre)