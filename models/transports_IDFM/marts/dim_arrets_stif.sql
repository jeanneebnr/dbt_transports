{{config(materialized='table')}}
SELECT 
id_transporteur_stif,
id_reseau_stif,
libelle_arret,
id_zone_arret

from {{ref('stg_nb_fer_2023_s1')}}  al


