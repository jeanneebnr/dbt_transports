SELECT
    * EXCEPT(time),
    time AS `date`
FROM {{ source('idfm', 'meteo_paris_2023_2024') }}