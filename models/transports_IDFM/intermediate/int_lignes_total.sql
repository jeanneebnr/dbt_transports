{{ config(materialized='table') }}

WITH stif AS (
    SELECT privatecode, id_ligne_stif, libelle_ligne
    FROM {{ ref('int_lignes_stif') }}
),

idfm AS (
    SELECT id_ligne_idfm, libelle_ligne
    FROM {{ ref('int_lignes_idfm') }}
),

ref AS (
    SELECT privatecode, id_ligne_idfm, libelle_ligne
    FROM {{ ref('stg_lignes_referentiel') }}
),

-- Le référentiel est le pont central
-- On part de lui et on enrichit avec stif et idfm
joined AS (
    SELECT
        ref.privatecode,
        ref.id_ligne_idfm,

        -- STIF
        stif.id_ligne_stif,
        stif.libelle_ligne AS libelle_stif,

        -- IDFM
        idfm.libelle_ligne AS libelle_idfm,

        -- Libellé final
        COALESCE(ref.libelle_ligne, idfm.libelle_ligne, stif.libelle_ligne) AS libelle_ligne,

        -- Statut
        CASE
            WHEN stif.id_ligne_stif IS NOT NULL
             AND idfm.id_ligne_idfm IS NOT NULL THEN 'BOTH'
            WHEN stif.id_ligne_stif IS NOT NULL THEN 'STIF_ONLY'
            WHEN idfm.id_ligne_idfm IS NOT NULL THEN 'IDFM_ONLY'
            ELSE 'ORPHAN'
        END AS source_status,

        CASE WHEN stif.id_ligne_stif IS NOT NULL THEN TRUE ELSE FALSE END AS has_stif,
        CASE WHEN idfm.id_ligne_idfm IS NOT NULL THEN TRUE ELSE FALSE END AS has_idfm

    FROM ref
    LEFT JOIN stif ON ref.privatecode = stif.privatecode
    LEFT JOIN idfm ON ref.id_ligne_idfm = idfm.id_ligne_idfm
)

SELECT * FROM joined
ORDER BY id_ligne_idfm