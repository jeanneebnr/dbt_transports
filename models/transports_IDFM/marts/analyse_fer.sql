{{ config(
    materialized='table',
    partition_by={
        "field": "date",
        "data_type": "date"
    },
    cluster_by=["id_ligne", "heure"]
) }}


WITH fer AS (

    SELECT*
    FROM {{ ref('fact_heure_estimation_fer') }}
),

meteo AS (

    SELEct*

    FROM {{ ref('fact_meteo') }}
)


SELECT

 
    b.date,
    b.heure,
    b.id_ligne,

 
    b.retard_moyen_minute,


    b.validations_estimees_heure,
    b.taux_service_pct,
    b.facteur_retard,
    b.incident_type,

  
    m.*except(date),
    

FROM fer b

LEFT JOIN meteo m
    ON m.date = b.date
