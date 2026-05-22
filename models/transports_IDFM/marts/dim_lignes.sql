{{ config(materialized='table') }}

WITH stif AS (

    SELECT
        privatecode,
        id_ligne_stif,
        libelle_ligne AS libelle_stif
    FROM {{ ref('int_lignes_stif') }}

),

idfm_usage AS (

    SELECT
        id_ligne_idfm,
        privatecode,
        libelle_ligne AS libelle_idfm_usage
    FROM {{ ref('int_lignes_idfm') }}

),

idfm_ref AS (

    SELECT
        id_ligne_idfm,
        privatecode,
        libelle_ligne AS libelle_idfm_ref
    FROM {{ ref('stg_lignes_referentiel') }}

)

SELECT

    s.privatecode,
    s.id_ligne_stif,

    i.id_ligne_idfm,

    COALESCE(
        r.libelle_idfm_ref,
        i.libelle_idfm_usage,
        s.libelle_stif
    ) AS libelle_ligne,

    CASE
        WHEN i.id_ligne_idfm IS NOT NULL THEN TRUE ELSE FALSE
    END AS has_idfm_usage,

    CASE
        WHEN r.id_ligne_idfm IS NOT NULL THEN TRUE ELSE FALSE
    END AS has_idfm_ref,

    CASE
        WHEN i.id_ligne_idfm IS NOT NULL AND r.id_ligne_idfm IS NOT NULL THEN 'FULL_MATCH'
        WHEN i.id_ligne_idfm IS NOT NULL THEN 'PARTIAL_IDFM'
        ELSE 'STIF_ONLY'
    END AS match_status

FROM stif s

LEFT JOIN idfm_usage i
    ON s.privatecode = i.privatecode

LEFT JOIN idfm_ref r
    ON i.privatecode = r.privatecode