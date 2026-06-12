{{ config(materialized='table') }}

WITH trafic AS (
    SELECT * FROM {{ ref('fact_trafic_heure') }}
),

meteo AS (
    SELECT * FROM {{ ref('fact_meteo') }}
),

calendrier AS (
    SELECT * FROM {{ ref('dim_date') }}
),

validations_jour AS (
    SELECT
        id_ligne,
        date,
        SUM(validations_nb) AS validations_nb_jour
    FROM {{ ref('fact_nb_surface') }}
    GROUP BY id_ligne, date
),



lignes AS (
    SELECT
        id_ligne,
        libelle_ligne,
        dsp,
        type_transport,
        surface_or_fer,
        libelle_transporteur,
        id_operateur
    FROM {{ ref('dim_lignes') }}
),
Transporteur as (
    Select
    id_ligne, 
    libelle_transporteur 
    from {{ref('dim_lignes')}})


SELECT
    t.*,
    m.* EXCEPT(date, id_meteo),
    c.* EXCEPT(date),
 
    vf.validations_nb_jour,
    l.* EXCEPT(id_ligne)

FROM trafic t
LEFT JOIN meteo m       ON t.date = m.date
LEFT JOIN calendrier c  ON t.date = c.date


LEFT JOIN validations_jour vf
    ON SAFE_CAST(t.id_ligne as STRING) = SAFE_CAST(vf.id_ligne as STRING) AND t.date = vf.date
LEFT JOIN lignes l      ON SAFE_CAST(t.id_ligne as STRING) = SAFE_CAST(l.id_ligne as STRING)
LEFT JOIN transporteur tr on SAFE_CAST(l.id_ligne as STRING)= SAFE_CAST (tr.id_ligne as string)