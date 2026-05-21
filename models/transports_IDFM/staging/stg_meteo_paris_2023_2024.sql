SELECT
    time AS `date`,
    * EXCEPT(time)
FROM {{ source('idfm', 'meteo_paris_2023_2024') }}