select
JOUR as date,
cast(CODE_STIF_TRNS as string) as CODE_STIF_TRNS,
cast(CODE_STIF_RES as string) as CODE_STIF_RES,
cast(CODE_STIF_LIGNE as string),
cast(LIBELLE_LIGNE as string),
cast(ID_GROUPOFLINES as string),
cast(CATEGORIE_TITRE as string) as CATEGORIE_TITRE,
cast(NB_VALD as float64 ) as NB_VALD

from {{source('idfm', 'nb_surface')}}







