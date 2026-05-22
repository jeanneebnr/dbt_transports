{{config(materialized='table')}}
SELECT DISTINCT
    id_zone_arret,
    categorie_jour,
    heure,
    validations_pct

FROM (
    SELECT id_zone_arret,categorie_jour,heure,validations_pct
    FROM {{ ref('stg_profil_fer_2024_s1') }}
     
    UNION ALL

    SELECT id_zone_arret,categorie_jour,heure,validations_pct
    FROM {{ ref('stg_profil_fer_2024_t3') }}

    UNION ALL

    SELECT id_zone_arret,categorie_jour,heure,validations_pct
    FROM {{ ref('stg_profil_fer_2023_s1') }}
    UNION ALL

    SELECT id_zone_arret,categorie_jour,heure,validations_pct
    FROM {{ ref('stg_profil_fer_2023_s2') }}
)
