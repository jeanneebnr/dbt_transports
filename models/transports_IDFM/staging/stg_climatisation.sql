SELECT
    * EXCEPT(nom_ligne),
    nom_ligne AS libelle_ligne
FROM {{ source('idfm', 'climatisation') }}