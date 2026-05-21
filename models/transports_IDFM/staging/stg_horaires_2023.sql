
select * EXCEPT (heure), 
    cast(heure as string) as heure
from {{source('idfm', 'horaires_2023')}}

