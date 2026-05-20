SELECT 
    id_stop_point as id_arret_idmf,
    accessibility_level_id,
    accessibility_level_name,
    stop_name as nom_arret,
    lat,
    lon
from {{source('idfm', 'accessibilite_en_gare')}}