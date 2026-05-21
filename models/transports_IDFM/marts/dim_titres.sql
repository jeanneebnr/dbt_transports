{{config(materialized='table')}}

WITH clean AS (
    SELECT DISTINCT
        REPLACE(REPLACE(categorie_titre, 'Ã©', 'é'), 'ï¿½', 'é') AS titre
    FROM {{ ref('stg_nb_fer_2024_s1') }}
)

SELECT
    DENSE_RANK() OVER (ORDER BY titre) AS id_titre,
    titre
FROM clean
   


