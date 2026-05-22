{{ config(materialized='table') }}

WITH all_facts AS (

    SELECT
        SAFE_CAST(TRIM(id_transporteur_stif) AS INT64) AS id_transporteur_stif,
        SAFE_CAST(TRIM(id_reseau_stif) AS INT64) AS id_reseau_stif,
        SAFE_CAST(TRIM(id_ligne_stif) AS INT64) AS id_ligne_stif,
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
    WHERE id_transporteur_stif IS NOT NULL
      AND id_reseau_stif IS NOT NULL
      AND id_ligne_stif IS NOT NULL
      AND id_transporteur_stif >= 0
      AND id_reseau_stif >= 0
      AND id_ligne_stif >= 0

)

SELECT

    -- 👇 TES ALIAS EXACTS (NE PAS TOUCHER)
    CONCAT(
        LPAD(CAST(id_transporteur_stif AS STRING), 3, '0'),
        LPAD(CAST(id_reseau_stif AS STRING), 3, '0'),
        LPAD(CAST(id_ligne_stif AS STRING), 3, '0')
    ) AS privatecode,

    id_ligne_stif,

    libelle_ligne

FROM filtered