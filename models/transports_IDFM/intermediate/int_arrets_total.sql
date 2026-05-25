{{ config(materialized='table') }}

WITH stif AS (
    SELECT privatecode_arret, id_transporteur_stif, id_reseau_stif, id_arret_stif, id_zdc, libelle_arret
    FROM {{ ref('int_arrets_stif') }}
),

idfm AS (
    SELECT id_arret_idfm, libelle_arret
    FROM {{ ref('int_arrets_idfm') }}
),

ref AS (
    SELECT id_arret_idfm, id_zdc, libelle_arret
    FROM {{ ref('stg_arrets_referentiel') }}
),

joined AS (
    SELECT
        ref.id_arret_idfm,
        ref.id_zdc,
        stif.privatecode_arret,
        stif.id_arret_stif,
        COALESCE(idfm.libelle_arret, stif.libelle_arret, ref.libelle_arret) AS libelle_arret,
        CASE
            WHEN stif.id_zdc IS NOT NULL
             AND idfm.id_arret_idfm IS NOT NULL THEN 'BOTH'
            WHEN stif.id_zdc IS NOT NULL         THEN 'STIF_ONLY'
            WHEN idfm.id_arret_idfm IS NOT NULL  THEN 'IDFM_ONLY'
            ELSE 'ORPHAN'
        END AS source_status,
        CASE WHEN stif.id_zdc IS NOT NULL        THEN TRUE ELSE FALSE END AS has_stif,
        CASE WHEN idfm.id_arret_idfm IS NOT NULL THEN TRUE ELSE FALSE END AS has_idfm
    FROM ref
    LEFT JOIN stif ON ref.id_zdc = stif.id_zdc
    LEFT JOIN idfm ON ref.id_arret_idfm = idfm.id_arret_idfm
),

stif_only AS (
    SELECT
        CAST(NULL AS STRING) AS id_arret_idfm,
        stif.id_zdc,
        stif.privatecode_arret,
        stif.id_arret_stif,
        stif.libelle_arret   AS libelle_arret,
        'STIF_ONLY'          AS source_status,
        TRUE                 AS has_stif,
        FALSE                AS has_idfm
    FROM stif
    WHERE NOT EXISTS (SELECT 1 FROM ref WHERE ref.id_zdc = stif.id_zdc)
),

idfm_only AS (
    SELECT
        idfm.id_arret_idfm,
        CAST(NULL AS STRING) AS id_zdc,
        CAST(NULL AS STRING) AS privatecode_arret,
        CAST(NULL AS INT64)  AS id_arret_stif,
        idfm.libelle_arret   AS libelle_arret,
        'IDFM_ONLY'          AS source_status,
        FALSE                AS has_stif,
        TRUE                 AS has_idfm
    FROM idfm
    WHERE NOT EXISTS (SELECT 1 FROM ref WHERE ref.id_arret_idfm = idfm.id_arret_idfm)
)

SELECT * FROM joined
UNION ALL
SELECT * FROM stif_only
UNION ALL
SELECT * FROM idfm_only

ORDER BY id_zdc