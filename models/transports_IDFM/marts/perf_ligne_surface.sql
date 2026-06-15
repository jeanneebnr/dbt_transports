{{ config(materialized='table') }}

WITH validations_jour AS (
 
    SELECT
        date,
        id_ligne,
        private_code,
     
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
 
    FROM {{ ref('fact_nb_surface') }}
    GROUP BY date, id_ligne,private_code
 
),
 

 
dim_date_cte AS (
 
    SELECT * FROM {{ ref('dim_date') }}
 
),
 
p AS (
 
    SELECT * FROM {{ ref('fact_profil_surface') }}
 
)


 
SELECT
    v.date,
    v.id_ligne,
    d.libelle_ligne,  
    v.total_validations_jour,
    v.periode,
    dd.categorie_jour,
      
    p.heure,
    p.validations_pct,
    cast(round (v.total_validations_jour * (p.validations_pct/100)) as int64) AS validations_estimees_heure
    
 
FROM validations_jour v
LEFT JOIN dim_date_cte dd
    ON dd.date = v.date

Left join {{ref('dim_arrets_zdc')}}  da
    on safe_cast(v.private_code as string )= safe_cast(da.private_code_arret as string)
LEFT JOIN p
    ON safe_cast (p.private_code as string) = SAFE_CAST(v.private_code AS STRING)
    AND v.periode = p.periode
    AND dd.categorie_jour = p.categorie_jour

Left join {{ref('dim_lignes')}}  d
on safe_cast(d.private_code as string) = safe_cast(v.private_code as string)
 
ORDER BY v.periode, v.date
 