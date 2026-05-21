select
JOUR as date
cast(code_stif_trns as string) as code_stif_trns,
cast(code_stif_res as string) as code_stif_res,
cast(libelle_arret as string) as libelle_arret,
cast(id_zdc as string) as id_stop_idfm,
cast(categorie_titre as string),
cast (nb_valid as int)

from {{source('idfm','nb_fer_2023_s2')}}


row_number() over (
            partition by
                JOUR,
                CODE_STIF_ARRET,
                CATEGORIE_TITRE
        ) as rn

    from {{ source('idfm', 'nb_fer_2023_s2') }}

    where JOUR is not null
      and CODE_STIF_ARRET is not null
      and NB_VALD is not null
)

where rn = 1