# 🚇 Urban Moove — Analyse du réseau de transport francilien

> Projet final — Bootcamp Data Analyst · La Capsule · 2026

---

## 📌 Contexte métier

Urban Moove est un projet d'analyse de données du réseau de transport en commun d'Île-de-France.

L'objectif est d'identifier les facteurs influençant la **qualité de service** et la **fréquentation** des lignes IDFM, en croisant :
- des données de **ponctualité et d'incidents** (horaires théoriques vs réels)
- des données de **fréquentation** par arrêt, ligne et titre de transport
- des données d'**accessibilité** en gare
- des données de **perception usager** (indicateurs de satisfaction)
- des données **météorologiques** (croisement météo / fréquentation)

---

## 🏗️ Architecture du pipeline

```
Fichiers bruts (CSV / TXT — open data IDFM)
        │
        ▼
  Audit & Nettoyage     ←  Python / Pandas
        │
        ▼
  BigQuery (raw)        ←  Chargement des tables sources
        │
        ▼
  DBT Cloud             ←  Modélisation en 3 couches
  ├── stg_  (vues)          Standardisation des sources
  ├── int_  (tables)        Jointures & réconciliation métier
  └── dim_ / fact_          Schéma en constellation analytique
        │
        ▼
  Power BI              ←  Visualisation & dashboards
```

---

## 📂 Structure du projet DBT

```
models/
└── transports_IDFM/
    ├── staging/          # Vues — standardisation des sources brutes BigQuery
    ├── intermediate/     # Tables — réconciliation STIF / IDFM, jointures métier
    └── marts/            # Tables — schéma en constellation (dim_ + fact_)
seeds/                    # Tables statiques (jours fériés, vacances scolaires Zone C)
tests/                    # Tests de qualité des données
```

### Détail des couches

**`staging/`** — Un modèle par fichier source. Renommage, typage, nettoyage léger.
Convention : `stg_<dataset>.sql`

**`intermediate/`** — La couche métier centrale. Elle résout le principal défi technique du projet : **deux référentiels coexistent** (STIF, l'ancien système, et IDFM, le nouveau). Cette couche les réconcilie en une table unifiée avec un indicateur de qualité `source_status` (`BOTH` / `STIF_ONLY` / `IDFM_ONLY` / `ORPHAN`).
Convention : `int_<objet>.sql`

**`marts/`** — Tables analytiques finales consommées par Power BI.
Convention : `dim_<objet>.sql` et `fact_<objet>.sql`

---

## 🗂️ Sources de données

| Fichier source | Description | Format |
|---|---|---|
| `accessibilite-en-gare.csv` | Niveau d'accessibilité par arrêt | CSV (`;`) |
| `arrets-lignes.csv` | Référentiel arrêts × lignes IDFM | CSV (`;`) |
| `horaires_2023/2024.csv` | Ponctualité et incidents par ligne et par heure | CSV |
| `indicateurs-de-perception-qs.csv` | Satisfaction usager par ligne | CSV (`;`) |
| `sdap-lignes-bus-inscrites.csv` | Équipement climatisation des bus | CSV (`;`) |
| `liste-transporteurs.csv` | Référentiel opérateurs de transport | CSV (`;`) |
| `meteo_paris_2023_2024.csv` | Données météo journalières | CSV (`;`) |
| `nb_fer / nb_surface` (2023–2024) | Validations par arrêt et titre de transport | TXT (tab) |
| `profil_fer / profil_surface` (2023–2024) | Profil horaire des validations | TXT (tab) |

---

## 🌐 Schéma en constellation

Le modèle analytique repose sur un **schéma en constellation** : plusieurs tables de faits partagent des dimensions communes.

```
                        DIM_lignes
                       ╱    │    ╲
        Fact_Trafic_Heure   │   Fact_NB_Surface
                            │   Fact_Profil_Surface
               DIM_arrets_zdc ── Fact_NB_Fer
                            │    Fact_Profil_Fer
                            │    Fact_accessibilite_en_gare
               DIM_categorie_titres ─ Fact_NB_Fer / Fact_NB_Surface
               DIM_date ─── Fact_Trafic_Heure
               Fact_Meteo  (données météo journalières)
```

| Dimension partagée | Tables de faits associées |
|---|---|
| `dim_lignes` | Fact_Trafic_Heure, Fact_NB_Surface, Fact_Profil_Surface |
| `dim_arrets_zdc` | Fact_NB_Fer, Fact_Profil_Fer, Fact_accessibilite_en_gare |
| `dim_categorie_titres` | Fact_NB_Fer, Fact_NB_Surface |
| `dim_date` | Fact_Trafic_Heure |

---

## ⚙️ Stack technique

| Outil | Usage |
|---|---|
| **Python / Pandas** | Audit, nettoyage, chargement BigQuery |
| **Google BigQuery** | Data warehouse |
| **DBT Cloud** | Transformation & modélisation (3 couches) |
| **Power BI** | Visualisation & dashboards |
| **GitHub** | Versioning du projet DBT |

---

## 🔑 Points techniques clés

### Réconciliation des référentiels STIF / IDFM
Le réseau francilien dispose de deux systèmes d'identification historiques. Le modèle `int_lignes_total` les réconcilie en détectant pour chaque ligne sa présence dans l'un, l'autre, ou les deux systèmes — avec gestion explicite des orphelins.

### Classification surface / fer
Le modèle `dim_lignes` classifie chaque ligne selon 3 niveaux de fallback successifs : type de transport déclaré → préfixe du code STIF → libellé de la ligne. Cela permet de couvrir 100% du référentiel même pour les lignes mal documentées.

### Catégorisation des jours
Le modèle `dim_date` applique la nomenclature métier transport IDFM : `JOHV` (jour ouvrable hors vacances), `JOVS`, `SAHV`, `SAVS`, `DIJFP` — indispensable pour des comparaisons de fréquentation cohérentes.

---

## 🚀 Lancer le projet

```bash
# Installer les dépendances
dbt deps

# Lancer tous les modèles
dbt run

# Lancer les tests de qualité
dbt test

# Générer et consulter la documentation
dbt docs generate
dbt docs serve
```

---

## 👥 Équipe

Ines, Jeanne et Rudy.
Projet réalisé dans le cadre du bootcamp **Data Analyst — La Capsule** (2026).