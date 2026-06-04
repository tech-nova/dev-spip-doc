# Tâches Cron et Attributs

Cette page **explique** le modèle de tâches de fond de SPIP 5.0.
Pour déclarer ou migrer une tâche dans un plugin, voir [Migrer les tâches cron](../upgrade/cron-taches-attributs.md).

## En bref

Les tâches cron se déclarent avec **`#[AsCronTask]`** sur une classe ou une méthode,
remplaçant le pipeline `taches_generales_cron` et `paquet.xml`.

## Contexte

Historiquement : XML + fonctions globales, code retour `>= 0` = succès.
SPIP 5.0 : services injectables, convention Unix (`0` = succès).

## Fonctionnement

- L’attribut porte un **nom** unique et une **période** minimale (60 s).
- La classe peut implémenter `__invoke()` ou exposer plusieurs méthodes annotées.
- Le conteneur découvre les tâches via autoconfigure, comme pour les listeners de pipelines.

## Différences avec SPIP 4.x

| SPIP 4.x | SPIP 5.0 |
|----------|----------|
| Pipeline `taches_generales_cron` | `#[AsCronTask]` |
| Déclaration dans `paquet.xml` | Code + `config/services.php` |
| Code retour `>= 0` | Code retour `0` = succès |

## Limites et pièges

- Les classes de tâches doivent être des **services** du plugin (autoload + `config/services.php`).
- Ne pas mélanger les conventions de code de retour legacy et moderne.

## Voir aussi

- [Migrer les tâches cron](../upgrade/cron-taches-attributs.md)
- [Services et injection de dépendances](services-symfony.md)
