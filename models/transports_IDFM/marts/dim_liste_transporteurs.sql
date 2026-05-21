 {{ config(materialized='table')  }}

 SELECT 
    ROW_NUMBER() OVER (ORDER BY libelle_transporteur) AS id_operateur_new,
     * 
 FROM  {{ ref('stg_liste_transporteurs')  }}


