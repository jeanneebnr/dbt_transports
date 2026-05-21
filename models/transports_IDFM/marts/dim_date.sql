{{ config(materialized='table') }}



select 
distinct date,
 annee, 
 jour_semaine,
  heure


from {{ref('stg_horaires_2023')}}