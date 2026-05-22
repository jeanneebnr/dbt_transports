{{config(materialized='table')}}

SELECT DISTINCT
    id_transporteur_stif,
    id_reseau_stif,
    id_ligne_stif,
    libelle_ligne,
    id_groupoflines

FROM (

    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne,
        id_groupoflines
    FROM {{ ref('stg_nb_surface_2023_t1') }}

    UNION ALL

    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne,
        id_groupoflines
    FROM {{ ref('stg_nb_surface_2023_t2') }}

    UNION ALL

    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne,
        id_groupoflines
    FROM {{ ref('stg_nb_surface_2023_t3') }}

    UNION ALL

    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne,
        id_groupoflines
    FROM {{ ref('stg_nb_surface_2023_t4') }}

    UNION ALL

    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne,
        id_groupoflines
    FROM {{ ref('stg_nb_surface_2024_t1') }}

    UNION ALL

    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne,
        id_groupoflines
    FROM {{ ref('stg_nb_surface_2024_t2') }}

    UNION ALL

    SELECT
        id_transporteur_stif,
        id_reseau_stif,
        id_ligne_stif,
        libelle_ligne,
        id_groupoflines
    FROM {{ ref('stg_nb_surface_2024_t3') }}

)