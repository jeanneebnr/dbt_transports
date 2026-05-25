{{ config(materialized='table') }}

WITH source AS (

    SELECT
       *
    FROM {{ ref('stg_nb_fer_2023_s1') }}

    UNION ALL

    SELECT
      *
    FROM {{ ref('stg_nb_fer_2023_s2') }}

    UNION ALL

    SELECT
        *
    FROM {{ ref('stg_nb_fer_2024_s1') }}

    UNION ALL

    SELECT*
    FROM {{ ref('stg_nb_fer_2024_t3') }}

)  

SELECT
    d.date,
    a.id_arret,
    nf.id_zone_arret,
    a.libelle_arret,
    t.titre,
    nf.validations_nb

FROM source  nf

JOIN {{ ref('dim_categorie_titres') }} t
    ON nf.categorie_titre = t.titre
Left JOIN {{ ref('dim_arrets_zdc') }} a on cast(a.id_arret as string ) = cast(nf.id_zone_arret as string)
JOIN {{ ref('dim_date') }} d
    USING (date)