SELECT
    * EXCEPT(operateur, mode, groupe_de_lignes, ligne),
    operateur        AS transporteur_name,
    mode             AS type_transport,
    groupe_de_lignes AS libelle_groupe_de_lignes,
    ligne            AS libelle_ligne
FROM {{ source('idfm', 'indicateurs_de_perception_qs') }}