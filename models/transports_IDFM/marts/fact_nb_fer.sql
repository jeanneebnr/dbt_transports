{{ config(materialized='table') }}

SELECT
    d.date,
    f.id_zone_arret,
    t.titre,
    f.validations_nb

FROM (

    SELECT
        date,
        id_zone_arret,
        categorie_titre,
        validations_nb
    FROM {{ ref('stg_nb_fer_2023_s1') }}

    UNION ALL

    SELECT
        date,
        id_zone_arret,
        categorie_titre,
        validations_nb
    FROM {{ ref('stg_nb_fer_2023_s2') }}

    UNION ALL

    SELECT
        date,
        id_zone_arret,
        categorie_titre,
        validations_nb
    FROM {{ ref('stg_nb_fer_2024_s1') }}

    UNION ALL

    SELECT
        date,
        id_zone_arret,
        categorie_titre,
        validations_nb
    FROM {{ ref('stg_nb_fer_2024_t3') }}

) f



JOIN {{ ref('dim_categorie_titres') }} t  on f.categorie_titre = t.titre
JOIN {{ ref('dim_date') }} d using(date)