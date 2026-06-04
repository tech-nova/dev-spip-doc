# Menus et onglets de l'espace privé

Cette page **explique** le modèle de navigation de l’espace privé en SPIP 5.0. Pour migrer depuis `paquet.xml`, voir le guide pratique.

## En bref

Les menus et onglets se déclarent dans **`config/menus.php`** et **`config/onglets.php`** (tableaux PHP), remplaçant les balises XML de `paquet.xml`.

## Contexte

La configuration de l’interface était dispersée dans `paquet.xml`.
Le format PHP statique s’aligne sur `services.php` et profite de l’OPcache.

## Fonctionnement

- **`config/menus.php`** : barre de navigation et sous-menus.
- **`config/onglets.php`** : onglets à l’intérieur d’une page `exec`.
- Chaque entrée est un tableau associatif (`titre`, `parent`, `icone`, `action`, etc.).

## Identifiants de menus standards

| Identifiant | Libellé SPIP 5.0 |
| :--- | :--- |
| `menu_accueil` | Accueil |
| `menu_edition` | Édition |
| `menu_publication` | Publication |
| `menu_activite` | Activité |
| `menu_apparence` | Apparence (ex-`menu_squelette`) |
| `menu_administration` | Maintenance |
| `menu_configuration` | Configuration |

## Différences avec SPIP 4.x

- Balises `<menu>` / `<onglet>` → fichiers PHP dédiés.
- `menu_squelette` → `menu_apparence` ; `bando_*` → `menu_*`.

## Voir aussi

- [Migrer menus et onglets](../upgrade/menus-onglets.md)
- [Espace privé — ruptures et UI](../upgrade/espace-prive-et-menus.md)
