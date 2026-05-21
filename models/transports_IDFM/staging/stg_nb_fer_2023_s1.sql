select
JOUR as date
cast(code_stif_trns as string) as code_stif_trns,
cast(code_stif_res as string) as code_stif_res,
cast(libelle_arret as string) as libelle_arret,
cast(lda as string) as id_stop_idfm,
cast(categorie_titre as string),
cast (nb_valid as int)

from {{source('idfm','nb_fer_2023_s1')}}
