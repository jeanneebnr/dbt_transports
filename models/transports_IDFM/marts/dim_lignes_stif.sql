{{ config(materialized='table') }}

SELECT DISTINCT
    TRIM(id_transporteur_stif)  AS id_transporteur_stif,
    TRIM(id_reseau_stif)        AS id_reseau_stif,
    TRIM(id_ligne_stif)         AS id_ligne_stif,
    libelle_ligne,
    TRIM(id_groupoflines)       AS id_groupoflines

FROM (
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupoflines
    FROM {{ ref('stg_nb_surface_2023_t1') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupoflines
    FROM {{ ref('stg_nb_surface_2023_t2') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupoflines
    FROM {{ ref('stg_nb_surface_2023_t3') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupoflines
    FROM {{ ref('stg_nb_surface_2023_t4') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupoflines
    FROM {{ ref('stg_nb_surface_2024_t1') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupoflines
    FROM {{ ref('stg_nb_surface_2024_t2') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupoflines
    FROM {{ ref('stg_nb_surface_2024_t3') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupofligne AS id_groupoflines
    FROM {{ ref('stg_profil_surface_2023_s1') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupofligne AS id_groupoflines
    FROM {{ ref('stg_profil_surface_2023_s2') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupofligne AS id_groupoflines
    FROM {{ ref('stg_profil_surface_2024_s1') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, id_ligne_stif, libelle_ligne, id_groupofligne AS id_groupoflines
    FROM {{ ref('stg_profil_surface_2024_t3') }}
)
WHERE libelle_ligne IS NOT NULL