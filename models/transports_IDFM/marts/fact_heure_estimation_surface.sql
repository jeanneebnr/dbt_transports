{{ config(
    materialized='table',
    partition_by={
        "field": "date",
        "data_type": "date",
        "granularity": "day"
    },
    cluster_by=["heure", "id_ligne"]
) }}
WITH fact AS (
    SELECT * FROM {{ ref('fact_trafic_heure') }}
),
perf_surface as (select date, id_ligne, heure,libelle_ligne, validations_estimees_heure from {{ref('perf_ligne_surface')}})

SELECT
   
    fa.date,
    fa.heure,
    f.validations_estimees_heure,
    fa.tranche_horaire,
    fa.id_ligne,
    f.libelle_ligne,
    fa.retard_moyen_minute,
    fa.incident_type,
    fa.facteur_retard,
    fa.taux_service_pct

FROM fact as fa

join perf_surface  f
on safe_cast(fa.id_ligne as string )=safe_cast(f.id_ligne as string)
and fa.date = f.date
and safe_cast (fa.heure as string) = safe_cast(f.heure as string)