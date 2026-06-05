# Menus et onglets de l'espace privé

En SPIP 5.0, les menus et onglets de l'espace privé se déclarent dans **`config/menus.php`** et **`config/onglets.php`**
(tableaux PHP statiques), remplaçant les balises XML de `paquet.xml`.
Le format profite de l'OPcache et s'aligne sur `services.php`.

!!! warning "Éléments susceptibles d’évolution"
    Le fonctionnement décrit pourrait évoluer avec des développements ultérieurs pour SPIP 5.0.

Déclarer ses menus dans un plugin : [Migrer menus et onglets](../guides/menus-onglets.md).

## Usage typique

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

- [Migrer menus et onglets](../guides/menus-onglets.md)
- [Espace privé — ruptures et UI](../guides/migration/espace-prive-et-menus.md)
