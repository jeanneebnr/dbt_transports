{{ config(materialized='table') }}

WITH all_facts AS (

    SELECT
        SAFE_CAST(TRIM(id_transporteur_stif) AS INT64) AS transporteur,
        SAFE_CAST(TRIM(id_reseau_stif) AS INT64) AS reseau,
        SAFE_CAST(TRIM(id_ligne_stif) AS INT64) AS ligne,
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2023_t1') }}

    UNION ALL

    SELECT
        SAFE_CAST(TRIM(id_transporteur_stif) AS INT64),
        SAFE_CAST(TRIM(id_reseau_stif) AS INT64),
        SAFE_CAST(TRIM(id_ligne_stif) AS INT64),
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2023_t2') }}

    UNION ALL

    SELECT
        SAFE_CAST(TRIM(id_transporteur_stif) AS INT64),
        SAFE_CAST(TRIM(id_reseau_stif) AS INT64),
        SAFE_CAST(TRIM(id_ligne_stif) AS INT64),
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2023_t3') }}

    UNION ALL

    SELECT
        SAFE_CAST(TRIM(id_transporteur_stif) AS INT64),
        SAFE_CAST(TRIM(id_reseau_stif) AS INT64),
        SAFE_CAST(TRIM(id_ligne_stif) AS INT64),
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2023_t4') }}

    UNION ALL

    SELECT
        SAFE_CAST(TRIM(id_transporteur_stif) AS INT64),
        SAFE_CAST(TRIM(id_reseau_stif) AS INT64),
        SAFE_CAST(TRIM(id_ligne_stif) AS INT64),
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2024_t1') }}

    UNION ALL

    SELECT
        SAFE_CAST(TRIM(id_transporteur_stif) AS INT64),
        SAFE_CAST(TRIM(id_reseau_stif) AS INT64),
        SAFE_CAST(TRIM(id_ligne_stif) AS INT64),
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2024_t2') }}

    UNION ALL

    SELECT
        SAFE_CAST(TRIM(id_transporteur_stif) AS INT64),
        SAFE_CAST(TRIM(id_reseau_stif) AS INT64),
        SAFE_CAST(TRIM(id_ligne_stif) AS INT64),
        libelle_ligne
    FROM {{ ref('stg_nb_surface_2024_t3') }}

),

filtered AS (

    SELECT *
    FROM all_facts
    WHERE transporteur IS NOT NULL
      AND reseau IS NOT NULL
      AND ligne IS NOT NULL
      AND transporteur >= 0
      AND reseau >= 0
      AND ligne >= 0

)

SELECT

    CONCAT(
        LPAD(CAST(transporteur AS STRING), 3, '0'),
        LPAD(CAST(reseau AS STRING), 3, '0'),
        LPAD(CAST(ligne AS STRING), 3, '0')
    ) AS privatecode,

    transporteur AS id_transporteur_stif,
    reseau AS id_reseau_stif,
    ligne AS id_ligne_stif,

    libelle_ligne

FROM filtered