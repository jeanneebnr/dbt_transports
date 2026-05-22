{{ config(materialized='table') }}

SELECT
    ROW_NUMBER() OVER (ORDER BY categorie_titre) AS id_titre,
    categorie_titre                               AS titre
FROM (
    SELECT DISTINCT TRIM(categorie_titre) AS categorie_titre FROM {{ source('idfm', 'nb_surface_2023_t1') }}
    UNION DISTINCT
    SELECT DISTINCT TRIM(categorie_titre) FROM {{ source('idfm', 'nb_surface_2023_t2') }}
    UNION DISTINCT
    SELECT DISTINCT TRIM(categorie_titre) FROM {{ source('idfm', 'nb_surface_2023_t3') }}
    UNION DISTINCT
    SELECT DISTINCT TRIM(categorie_titre) FROM {{ source('idfm', 'nb_surface_2023_t4') }}
    UNION DISTINCT
    SELECT DISTINCT TRIM(categorie_titre) FROM {{ source('idfm', 'nb_surface_2024_t1') }}
    UNION DISTINCT
    SELECT DISTINCT TRIM(categorie_titre) FROM {{ source('idfm', 'nb_surface_2024_t2') }}
    UNION DISTINCT
    SELECT DISTINCT TRIM(categorie_titre) FROM {{ source('idfm', 'nb_surface_2024_t3') }}
)