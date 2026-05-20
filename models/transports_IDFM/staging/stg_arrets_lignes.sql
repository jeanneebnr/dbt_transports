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
        cast(id_ligne_IDFM as string),
        cast(route_long_name as string) as ligne_name_long,
        cast(id_stop_IDFM as string),
        cast(stop_name as string) as nom_arret,
        cast(stop_lon as float64) as longitude,
        stop_lat,
        operatorname,
        shortname,
        bookingrules,
        mode,
        pointgeo,
        nom_commune,
        code_insee
    FROM deduplicated
)