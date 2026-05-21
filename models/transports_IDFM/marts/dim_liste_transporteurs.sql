 {{ config(materialized='table')  }}

 SELECT 
     * 
 FROM  {{ ref('stg_liste_transporteurs')  }}


