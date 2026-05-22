{{config(materialized = 'table')}}
WITH all_idfm AS (

    SELECT
        id_ligne_idfm,
        nom_ligne as libelle_ligne,
        'climatisation' AS source_table
    FROM {{ ref('stg_climatisation') }}

    UNION ALL

    SELECT
        id_ligne_idfm,
        libelle_ligne_court as libelle_ligne,
        'arrets_lignes'
    FROM {{ ref('stg_arrets_lignes') }}

    UNION ALL

    SELECT
        id_ligne_idfm,
        libelle_ligne,
        'indicateur_qs'
    FROM {{ ref('stg_indicateurs_de_perception_qs') }}

    UNION ALL

    SELECT
        id_ligne_idfm,
        ligne_nom AS libelle_ligne,
        'horaires_2023'
    FROM {{ ref('stg_horaires_2023') }}

    UNION ALL

    SELECT
        id_ligne_idfm,
        ligne_nom AS libelle_ligne,
        'horaires_2024'
    FROM {{ ref('stg_horaires_2024') }}

)

SELECT
    id_ligne_idfm,

    ANY_VALUE(libelle_ligne) AS libelle_ligne,

    COUNT(*) AS source_count

FROM all_idfm
GROUP BY id_ligne_idfm