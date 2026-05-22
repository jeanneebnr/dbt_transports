{{config(materialized='table')}}

SELECT DISTINCT
   id_groupofligne,categorie_jour,heure,validations_pct

FROM (

      SELECT
        id_groupofligne,categorie_jour,heure,validations_pct
    FROM {{ ref('stg_profil_surface_2023_s1') }}
      
    UNION ALL

    SELECT
        id_groupofligne,categorie_jour,heure,validations_pct
    FROM {{ ref('stg_profil_surface_2023_s2') }}
    
    UNION ALL

    SELECT
        id_groupofligne,categorie_jour,heure,validations_pct
    FROM {{ ref('stg_profil_surface_2024_s1') }}
    
    UNION ALL
    
    SELECT
       id_groupofligne,categorie_jour,heure,validations_pct
    FROM {{ ref('stg_profil_surface_2024_t3') }}

)