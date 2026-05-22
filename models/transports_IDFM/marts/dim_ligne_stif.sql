{{config(materialized='table')}}


select 
id_transporteur_stif,
id_reseau_stif,
id_ligne_stif,
libelle_ligne,
id_groupoflines

from {{ref('stg_nb_surface_2023_t1')}}