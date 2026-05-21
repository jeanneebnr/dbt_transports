
select time AS date
from {{source('idfm', 'meteo_paris_2023_2024')}}
