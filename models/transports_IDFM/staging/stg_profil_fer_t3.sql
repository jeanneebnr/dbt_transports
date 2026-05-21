select

cast (CODE_STIF_TRNS as string),
cast (CODE_STIF_RES as string),
cast (CODE_STIF_ARRET as string),
cast (LIBELLE_ARRET as string),
cast (ID_ZDC as string) as id_stop_IDFM,
cast (CAT_JOUR as string),
CAST(LEFT(TRNC_HORR_60, POSITION('-' IN TRNC_HORR_60) - 1) AS STRING) as par_heure ,
cast(Pourcentage_validations as float64)	


from {{source('idfm', 'profil_fer_T3_2024')}}







