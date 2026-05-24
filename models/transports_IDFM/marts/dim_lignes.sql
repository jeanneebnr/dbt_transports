{{ config(materialized='table') }}

WITH base AS (
    SELECT
        privatecode,
        id_ligne_idfm,
        id_ligne_stif,
        libelle_ligne
    FROM {{ ref('int_lignes_total') }}
    WHERE id_ligne_idfm IS NOT NULL
),

stif AS (
    SELECT
        privatecode,
        id_ligne_stif
    FROM {{ ref('int_lignes_stif') }}
),

arrets_lignes AS (
    SELECT
        id_ligne_idfm,
        libelle_ligne_court,
        type_transport AS type_transport_arrets,
        libelle_transporteur AS libelle_transporteur_arrets
    FROM {{ ref('stg_arrets_lignes') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY id_ligne_idfm ORDER BY id_ligne_idfm) = 1
),

indicateurs AS (
    SELECT
        id_ligne_idfm,
        type_transport AS type_transport_indicateurs,
        resultat AS indicateur_perception,
        transporteur_name AS libelle_transporteur_indicateurs
    FROM {{ ref('stg_indicateurs_de_perception_qs') }}
),

climatisation AS (
    SELECT
        id_ligne_idfm,
        climatisation
    FROM {{ ref('stg_climatisation') }}
),

transporteurs AS (
    SELECT
        transporteur_ref AS id_operateur,
        libelle_transporteur
    FROM {{ ref('stg_liste_transporteurs') }}
)

SELECT
    -- Nouvel ID technique
    ROW_NUMBER() OVER (ORDER BY base.id_ligne_idfm) AS id_ligne,

    -- Identifiants
    base.id_ligne_idfm,
    base.id_ligne_stif,
    base.privatecode,

    -- Libellé
    base.libelle_ligne,
    al.libelle_ligne_court,

    -- Type transport (les deux sources pour comparaison)
    al.type_transport_arrets,
    ind.type_transport_indicateurs,
    COALESCE(al.type_transport_arrets, ind.type_transport_indicateurs) AS type_transport,

    -- Surface or fer
    CASE
        WHEN COALESCE(al.type_transport_arrets, ind.type_transport_indicateurs) = 'Tramway'
             AND al.libelle_ligne_court IN ('T4', 'T11') THEN 'fer'
        WHEN COALESCE(al.type_transport_arrets, ind.type_transport_indicateurs) = 'Tramway' THEN 'surface'
        WHEN COALESCE(al.type_transport_arrets, ind.type_transport_indicateurs) IN (
            'RapidTransit', 'regionalRail', 'LocalTrain', 'RailShuttle', 'Metro'
        ) THEN 'fer'
        WHEN COALESCE(al.type_transport_arrets, ind.type_transport_indicateurs) IN (
            'Bus', 'Funicular'
        ) THEN 'surface'
        ELSE 'non classifié'
    END AS surface_or_fer,

    -- Climatisation
    clim.climatisation,

    -- Indicateur de perception
    ind.indicateur_perception,

    -- Transporteur (les deux sources pour comparaison)
    al.libelle_transporteur_arrets,
    ind.libelle_transporteur_indicateurs,
    COALESCE(al.libelle_transporteur_arrets, ind.libelle_transporteur_indicateurs) AS libelle_transporteur,

    -- Opérateur
    tr.id_operateur

FROM base
LEFT JOIN arrets_lignes al      ON base.id_ligne_idfm = al.id_ligne_idfm
LEFT JOIN indicateurs ind       ON base.id_ligne_idfm = ind.id_ligne_idfm
LEFT JOIN climatisation clim    ON base.id_ligne_idfm = clim.id_ligne_idfm
LEFT JOIN transporteurs tr      ON COALESCE(
                                        al.libelle_transporteur_arrets,
                                        ind.libelle_transporteur_indicateurs
                                    ) = tr.libelle_transporteur