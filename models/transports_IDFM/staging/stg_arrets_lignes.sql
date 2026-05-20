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
                ORDER BY  ASC
            ) AS row_num
        FROM source_data
    )
    WHERE row_num = 1
),