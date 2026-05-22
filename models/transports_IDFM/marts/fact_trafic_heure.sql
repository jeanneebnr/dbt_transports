{{ config(materialized='table') }}

WITH union_horaires AS (
    SELECT * FROM {{ source('idfm', 'horaires_2023') }}
    UNION ALL
    SELECT * FROM {{ source('idfm', 'horaires_2024') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY CAST(date AS DATE), CAST(heure AS INT64)) AS id_trafic,
    CAST(date AS DATE)                                AS date,
    CAST(heure AS INT64)                              AS heure,
    CAST(tranche_horaire AS STRING)                   AS tranche_horaire,
    CAST(id_ligne_IDFM AS STRING)                     AS id_ligne,
    CAST(frequence_theorique_par_heure AS FLOAT64)    AS freq_theo,
    CAST(frequence_reelle_par_heure AS FLOAT64)       AS freq_reel,
    CAST(taux_service_pct AS FLOAT64)                 AS taux_service_pct,
    CAST(retard_moyen_minutes AS FLOAT64)             AS retard_moyen_minute,
    CAST(facteur_retard AS FLOAT64)                   AS facteur_retard,
    CAST(incident_detecte AS BOOL)                    AS incident_detecte,
    CAST(incident_type AS STRING)                     AS incident_type

FROM union_horaires