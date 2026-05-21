{{ config(materialized='table') }}
SELECT 
    al.id_stop_IDFM,
    al.id_ligne_idfm,
    al.libelle_arret,
    al.longitude,
    al.latitude,
    a.niveau_accessibilite,
    al.ville,
    al.code_postal

FROM {{ ref('stg_arrets_lignes') }} al
LEFT JOIN {{ ref('stg_accessibilite_en_gare') }} a
    ON al.id_stop_IDFM = a.id_stop_IDFM
Where libelle_arret = 'Mantes-la-Jolie'

order by id_ligne_IDFM