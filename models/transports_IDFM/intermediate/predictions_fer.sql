WITH zdc_ref AS (
    SELECT
        ref.id_zdc,
        ANY_VALUE(al.ville) AS ville,
        ANY_VALUE(al.code_postal) AS code_postal,
        ANY_VALUE(al.latitude) AS latitude,
        ANY_VALUE(al.longitude) AS longitude
    FROM {{ ref('stg_arrets_lignes') }} al
    LEFT JOIN {{ ref('stg_arrets_referentiel') }} ref
        ON al.id_stop_idfm = ref.id_arret_idfm
    WHERE ref.id_zdc IS NOT NULL
    GROUP BY ref.id_zdc
),
meteo AS (
    SELECT * FROM {{ ref('fact_meteo') }}
),
calendrier as (select*from {{ref('dim_date')}}),

Transporteur as (
    Select
    id_ligne,
    type_transport, 
    libelle_transporteur 
    from {{ref('dim_lignes')}})

SELECT
    traf.*EXCEPT(date),
    m.*EXCEPT(date,id_meteo),
    c.*EXCEPT(date),
    t. type_transport,
    t.libelle_transporteur,
    v.date,
    v.validations_nb,
    da.id_arret,
    da.libelle_arret,
    da.id_zdc,
    

FROM {{ ref('fact_nb_fer') }} v
left join meteo m on m.date=v.date
LEFT JOIN calendrier c  ON v.date = c.date
JOIN {{ ref('dim_arrets_zdc') }} da
    ON v.id_arret = da.id_arret
LEFT JOIN zdc_ref z
    ON da.id_zdc = z.id_zdc

LEFT JOIN {{ ref('dim_arrets_lignes') }} cal
    ON SAFE_CAST(da.id_zdc as string) = safe_cast(cal.id_arret_zdc as string)
left Join transporteur t on t.id_ligne=cal.id_ligne 
LEFT JOIN {{ ref('fact_trafic_heure') }} traf
    ON safe_cast(cal.id_ligne as string) = safe_cast(traf.id_ligne as string)
    AND v.date = traf.date