select
JOUR as date,
cast(CODE_STIF_TRNS as string) as CODE_STIF_TRNS,
cast(CODE_STIF_RES as string) as CODE_STIF_RES,
cast(CODE_STIF_ARRET as string) as CODE_STIF_ARRET,
cast(LIBELLE_ARRET as string) as  LIBELLE_ARRET,
cast(ID_ZDC as string) as  id_stop_IDFM,
cast(CATEGORIE_TITRE as string) as CATEGORIE_TITRE,
cast(NB_VALD as float64 ) as NB_VALD

from {{source('idfm', 'profil_fer_T3_2024')}}





