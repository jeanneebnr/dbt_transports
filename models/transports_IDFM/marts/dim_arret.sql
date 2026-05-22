{{config(materialized='table')}}
SELECT 
al.id_stop_idfm,
al.id_ligne_idfm,
al.libelle_arret,
al.longitude,
al.latitude,
a.niveau_accessibilite,
a.note_accessibilite,
al.ville,
al.code_postal

from {{ref('stg_arrets_lignes')}}  al
left join  {{ref('stg_accessibilite_en_gare')}}  a using (id_stop_IDFM)

