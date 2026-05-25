{{ config(materialized='table') }}

WITH arrets_lignes AS (

    SELECT
        id_stop_idfm    AS id_arret_idfm,
        libelle_arret,
        ville,
        code_postal,
        latitude,
        longitude,
        type_transport,
        reservation
    FROM {{ ref('stg_arrets_lignes') }}

),

accessibilite AS (

    SELECT
        id_stop_idfm        AS id_arret_idfm,
        niveau_accessibilite,
        note_accessibilite,
        latitude,
        longitude
    FROM {{ ref('stg_accessibilite_en_gare') }}

),

joined AS (

    SELECT
        al.id_arret_idfm,
        al.libelle_arret,
        al.ville,
        al.code_postal,
        COALESCE(al.latitude, acc.latitude)   AS latitude,
        COALESCE(al.longitude, acc.longitude) AS longitude,
        al.type_transport,
        al.reservation,
        acc.niveau_accessibilite,
        acc.note_accessibilite
    FROM arrets_lignes al
    LEFT JOIN accessibilite acc ON al.id_arret_idfm = acc.id_arret_idfm

)

SELECT
    id_arret_idfm,
    libelle_arret,
    ville,
    code_postal,
    latitude,
    longitude,
    type_transport,
    reservation,
    niveau_accessibilite,
    note_accessibilite
FROM joined
QUALIFY ROW_NUMBER() OVER (PARTITION BY id_arret_idfm ORDER BY LENGTH(libelle_arret) DESC) = 1