SELECT
    * EXCEPT(code_stif_trns, code_stif_res, code_stif_ligne, cat_jour, trnc_horr_60, pourc_validations),

    -- Renommage simple
    code_stif_res                        AS id_reseau_stif,
    code_stif_ligne                      AS id_ligne_stif,
    
    
    trnc_horr_60                         AS heure,
    cat_jour                             AS categorie_jour,

    -- Cast + renommage
    CAST(code_stif_trns AS STRING)       AS id_transporteur_stif,
    CAST(replace(CAST(pourc_validations as STRING),",",".") AS FLOAT64)   AS validations_pct

FROM {{ source('idfm', 'profil_surface_2023_s1') }}