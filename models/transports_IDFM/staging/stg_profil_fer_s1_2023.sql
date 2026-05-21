select

SAFE_cast (CODE_STIF_TRNS as string) as CODE_STIF_TRNS,
SAFE_cast (CODE_STIF_RES as string)as CODE_STIF_RES,
SAFE_cast (CODE_STIF_ARRET as string) as CODE_STIF_ARRET,
SAFE_cast (LIBELLE_ARRET as string)as LIBELLE_ARRET,
SAFE_cast (lda as string) as id_stop_IDFM,
cast (CAT_JOUR as string) as CAT_JOUR,
CAST( REGEXP_EXTRACT(TRNC_HORR_60, r'^[^-]+') AS STRING) as heure,
cast(pourc_validations as float64)


from {{source('idfm', 'profil_fer_s1_2023')}}







