{{ config(materialized='table') }}

SELECT DISTINCT
    id_transporteur_stif,
    id_reseau_stif,
    libelle_arret,
    id_zone_arret

FROM (
    SELECT id_transporteur_stif, id_reseau_stif, libelle_arret, id_zone_arret
    FROM {{ ref('stg_nb_fer_2023_s1') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, libelle_arret, id_zone_arret
    FROM {{ ref('stg_nb_fer_2023_s2') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, libelle_arret, id_zone_arret
    FROM {{ ref('stg_nb_fer_2024_s1') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, libelle_arret, id_zone_arret
    FROM {{ ref('stg_nb_fer_2024_t3') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, libelle_arret, id_zone_arret
    FROM {{ ref('stg_profil_fer_2024_s1') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, libelle_arret, id_zone_arret
    FROM {{ ref('stg_profil_fer_2024_t3') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, libelle_arret, id_zone_arret
    FROM {{ ref('stg_profil_fer_2023_s1') }}
    UNION ALL
    SELECT id_transporteur_stif, id_reseau_stif, libelle_arret, id_zone_arret
    FROM {{ ref('stg_profil_fer_2023_s2') }}
)
WHERE id_reseau_stif IS NOT NULL