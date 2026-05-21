WITH source_data as (
    SELECT *
    FROM {{source('idfm', 'profil_fer_2023_s1')}}
),

deduplicated as (
        SELECT *
    FROM (
        SELECT
            *,
            row_number() OVER (
                PARTITION BY libelle_arret, cat_jour, trnc_horr_60
                ORDER BY libelle_arret
            ) AS row_num
        FROM source_data
    )
    WHERE row_num = 1
),

clean_data as (
    SELECT 
        cast(code_stif_trns as string) as id_transporteur_stif,
        cast(code_stif_res as string) as id_reseau_stif,
        cast(code_stif)
)