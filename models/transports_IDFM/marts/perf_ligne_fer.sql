{{ config(materialized='table') }}

WITH 
validations_jour AS (
 
    SELECT
        date,
        id_arret,
     
        SUM(validations_nb) AS total_validations_jour,
        CASE
            WHEN EXTRACT(YEAR FROM date) = 2023 THEN
                CONCAT('2023_s', CAST(CASE WHEN EXTRACT(MONTH FROM date) <= 6 THEN 1 ELSE 2 END AS STRING))
            WHEN EXTRACT(YEAR FROM date) = 2024 THEN
                CASE
                    WHEN EXTRACT(MONTH FROM date) <= 6 THEN '2024_s1'
                    WHEN EXTRACT(MONTH FROM date) <= 9 THEN '2024_t3'
                    ELSE NULL
                END
            ELSE NULL
        END AS periode
 
    FROM {{ ref('fact_nb_fer') }}
    GROUP BY date, id_arret
 
),
 

 
dim_date_cte AS (
 
    SELECT * FROM {{ ref('dim_date') }}
 
),
 
p AS (
 
    SELECT * FROM {{ ref('fact_profil_fer') }}
 
)


 
SELECT
    v.date,
    da.id_arret,
    
    v.total_validations_jour,
    v.periode,
    dd.categorie_jour,
    da.libelle_arret,
   
    p.heure,
    p.validations_pct,
    cast (round(v.total_validations_jour * (p.validations_pct/100)) as int64) AS validations_estimees_heure,

 
FROM validations_jour v
JOIN {{ ref('dim_arrets_zdc') }} da
    ON v.id_arret = da.id_arret
LEFT JOIN {{ ref('dim_arrets_lignes') }} cal
    ON SAFE_CAST(da.id_zdc AS STRING) = SAFE_CAST(cal.id_arret_zdc AS STRING)

LEFT JOIN dim_date_cte dd
    ON dd.date = v.date
LEFT JOIN p
    ON v.id_arret = p.id_arret
    AND v.periode = p.periode
    AND dd.categorie_jour = p.categorie_jour


ORDER BY v.periode, v.date
 