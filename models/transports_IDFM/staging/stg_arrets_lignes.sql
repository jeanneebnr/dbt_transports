WITH source_data AS (
    SELECT * 
    FROM {{source('idfm', 'arrets_lignes')}}
),

deduplicated AS (
    SELECT *
    FROM (
        SELECT
            *,
            row_number() OVER (
                PARTITION BY id_ligne_IDFM, id_stop_IDFM
            ) AS row_num
        FROM source_data
    )
    WHERE row_num = 1
),

clean_data AS (
    SELECT 
        cast(id_ligne_IDFM AS string),
        cast(route_long_name AS string) AS libelle_ligne_long,
        cast(id_stop_IDFM AS string),
        cast(stop_name AS string) AS libelle_arret,
        cast(stop_lon AS float64) AS longitude,
        cast(stop_lat AS float64) AS latitude,
        cast(operatorname AS string) AS transporteur,
        cast(shortname AS string) AS libelle_ligne_court,
        COALESCE(cast(bookingrules AS string), 'pas de réservation') AS reservation,
        cast(mode AS string) AS type_transport,
        cast(nom_commune AS string),
        cast(code_insee AS string) as code_postal
    FROM deduplicated
),

SELECT *
FROM clean_data