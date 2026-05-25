{{ config(materialized='table') }}

WITH source AS (

    SELECT *
    FROM {{ ref('stg_profil_fer_2024_s1') }}

    UNION ALL

    SELECT *
    FROM {{ ref('stg_profil_fer_2024_t3') }}

    UNION ALL

    SELECT *
    FROM {{ ref('stg_profil_fer_2023_s1') }}

    UNION ALL

    SELECT *
    FROM {{ ref('stg_profil_fer_2023_s2') }}

)

SELECT DISTINCT
    dl.id_ligne,
    dl.privatecode,
    nf.libelle_arret,
    nf.categorie_jour,
    nf.heure,
    nf.validations_pct

FROM source nf

JOIN {{ ref('dim_lignes') }} dl
ON CONCAT(
    TRIM(CAST(nf.id_transporteur_stif AS STRING)),TRIM(CAST(nf.id_reseau_stif AS STRING)),
    TRIM(CAST(nf.id_arret_stif AS STRING))) = TRIM(dl.privatecode)