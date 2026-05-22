{{ config(materialized='table') }}

SELECT
    id_stop_idfm,
    libelle_arret,
    longitude,
    latitude,
    niveau_accessibilite,
    note_accessibilite,
    ville,
    code_postal

FROM (
    SELECT
        al.id_stop_idfm,
        al.libelle_arret,
        al.longitude,
        al.latitude,
        a.niveau_accessibilite,
        a.note_accessibilite,
        al.ville,
        al.code_postal,
        ROW_NUMBER() OVER (PARTITION BY al.id_stop_idfm ORDER BY al.id_stop_idfm) AS row_num
    FROM {{ ref('stg_arrets_lignes') }} AS al
    LEFT JOIN {{ ref('stg_accessibilite_en_gare') }} AS a
        USING (id_stop_idfm)
) AS ranked
WHERE row_num = 1