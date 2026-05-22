{{config(materialized='table')}}

SELECT 
    id_ligne_idfm,
    id_stop_idfm
FROM {{ref('stg_arrets_lignes')}}