SELECT
    operatorname       AS transporteur_name,
    operatorref        AS transporteur_ref,
    housenumber,
    street,
    addressline1,
    town,
    postcode,
    postcodeextension,
    phone,
    url,
    furtherdetails,
    contactperson,
    logo,
    email
FROM {{ source('idfm', 'liste_transporteurs') }}


