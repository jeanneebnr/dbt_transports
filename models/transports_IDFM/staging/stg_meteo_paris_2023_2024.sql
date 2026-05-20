
select *
from {{source('idfm', 'meteo_paris_2023_2024')}}

SELECT
    time AS date,    -- ← alias : time devient date
  
FROM `projet-final-496714.raw_pre_traitees.meteo_paris_2023_2024`