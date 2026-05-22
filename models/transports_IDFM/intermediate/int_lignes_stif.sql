{{config(materialized = 'table')}}

WITH all_facts AS (

    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2023_t1') }}

    UNION ALL
    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2023_t2') }}

    UNION ALL
    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2023_t3') }}

    UNION ALL
    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2023_t4') }}

    UNION ALL
    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2024_t1') }}

    UNION ALL
    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2024_t2') }}

    UNION ALL
    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2024_t3') }}

)

SELECT DISTINCT

    CONCAT(
        LPAD(TRIM(CAST(id_transporteur_stif AS STRING)), 3, '0'),
        LPAD(TRIM(CAST(id_reseau_stif AS STRING)), 3, '0'),
        LPAD(TRIM(CAST(id_ligne_stif AS STRING)), 3, '0')
    ) AS privatecode,

    ANY_VALUE(libelle_ligne) AS libelle_ligne

FROM all_facts

WHERE id_transporteur_stif IS NOT NULL
  AND id_reseau_stif IS NOT NULL
  AND id_ligne_stif IS NOT NULL

GROUP BY privatecode