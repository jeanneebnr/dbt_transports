{{ config(materialized='table') }}

WITH stif AS (

    SELECT
        privatecode,
        id_ligne_stif,
        libelle_ligne
    FROM {{ ref('int_lignes_stif') }}

),

idfm AS (

    SELECT
        id_ligne_idfm,
        libelle_ligne
    FROM {{ ref('int_lignes_idfm') }}

),

ref AS (

    SELECT
        privatecode,
        id_ligne_idfm,
        libelle_ligne
    FROM {{ ref('stg_lignes_referentiel') }}

),

-- base = toutes les clés existantes
base AS (

    SELECT privatecode FROM stif

    UNION DISTINCT

    SELECT privatecode FROM ref

    UNION DISTINCT

    SELECT r.privatecode
    FROM idfm i
    JOIN ref r
        ON i.id_ligne_idfm = r.id_ligne_idfm

)

SELECT

    b.privatecode,

    -- STIF
    s.id_ligne_stif,
    s.libelle_ligne AS libelle_stif,

    -- IDFM
    r.id_ligne_idfm,
    i.libelle_ligne AS libelle_idfm,

    -- libellé final
    COALESCE(
        r.libelle_ligne,
        i.libelle_ligne,
        s.libelle_ligne
    ) AS libelle_ligne,

    -- statut
    CASE
        WHEN s.id_ligne_stif IS NOT NULL
         AND i.id_ligne_idfm IS NOT NULL THEN 'BOTH'

        WHEN s.id_ligne_stif IS NOT NULL THEN 'STIF_ONLY'

        WHEN i.id_ligne_idfm IS NOT NULL THEN 'IDFM_ONLY'

        ELSE 'ORPHAN'
    END AS source_status,

    -- flags
    CASE WHEN s.id_ligne_stif IS NOT NULL THEN TRUE ELSE FALSE END AS has_stif,

    CASE WHEN i.id_ligne_idfm IS NOT NULL THEN TRUE ELSE FALSE END AS has_idfm

FROM base b

LEFT JOIN stif s
    ON b.privatecode = s.privatecode

LEFT JOIN ref r
    ON b.privatecode = r.privatecode

LEFT JOIN idfm i
    ON r.id_ligne_idfm = i.id_ligne_idfm
    