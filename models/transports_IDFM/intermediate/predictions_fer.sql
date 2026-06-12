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

validations_fer_jour AS (
    SELECT
        id_arret,
        date,
        SUM(validations_nb) AS validations_nb_jour
    FROM {{ ref('fact_nb_fer') }}
    GROUP BY id_arret, date
),


lignes AS (
    SELECT
        id_arret_zdc,
        id_ligne,
        
    FROM {{ ref('dim_arrets_lignes') }}
),

arret AS (
    SELECT
        id_zdc,
        libelle_arret
    FROM {{ ref('dim_arrets_zdc') }}
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
    a.libelle_arret,
    tr.libelle_transporteur

FROM trafic t
LEFT JOIN meteo m       ON t.date = m.date
LEFT JOIN calendrier c  ON t.date = c.date

LEFT JOIN lignes l on SAFE_CAST(t.id_ligne as STRING)= SAFE_CAST (l.id_ligne as string)
LEFT JOIN arret  a on SAFE_CAST(l.id_arret_zdc as string )= SAFE_CAST (a.id_zdc as STRING)

LEFT JOIN validations_fer_jour vf
    ON SAFE_CAST(a.id_zdc as STRING) = SAFE_CAST(vf.id_arret as STRING) AND t.date = vf.date

LEFT JOIN transporteur tr on SAFE_CAST(l.id_ligne as STRING)= SAFE_CAST (tr.id_ligne as string)


