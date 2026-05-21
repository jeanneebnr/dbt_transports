{{ config (materialized ='table')}}


SELECT DISTINCT
    c.id_ligne_IDFM, 
    al.libelle_ligne_long,
    al.libelle_ligne_court,
    lt.transporteur_ref,
    al.reservation,
    al.type_transport,
    ip.libelle_groupe_de_lignes,
    CASE
        WHEN al.type_transport = 'Tramway'
            AND al.libelle_ligne_court IN ('T4', 'T11')
            THEN 'fer'

        WHEN al.type_transport = 'Tramway'
            THEN 'surface'

        WHEN al.type_transport IN (
            'RapidTransit',
            'regionalRail',
            'LocalTrain',
            'RailShuttle',
            'Metro'
        )   THEN 'fer'

        WHEN al.type_transport IN (
            'Bus',
            'Funicular'
        )   THEN 'surface'

        ELSE 'non classifié'
    END AS surface_or_fer,
    c.climatisation,
    ip.resultat
FROM {{ref('stg_climatisation')}} as c
LEFT JOIN {{ref('stg_arrets_lignes')}} as al
ON c.id_ligne_IDFM = al.id_ligne_IDFM
LEFT JOIN {{ref('stg_liste_transporteurs')}} as lt
ON al.libelle_transporteur = lt.libelle_transporteur
LEFT JOIN {{ref('stg_indicateurs_de_perception_qs')}} as ip
ON c.id_ligne_IDFM = ip.id_ligne_IDFM
ORDER BY id_ligne_IDFM