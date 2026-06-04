# Services et injection de dépendances

Cette page **explique** l’intégration du conteneur de services Symfony dans SPIP 5.0. Pour configurer un plugin, voir le guide pratique.

## En bref

SPIP 5.0 utilise le **conteneur de services Symfony** : autowiring, autoconfiguration des attributs, paramètres `spip.*` injectables dans les définitions de services.

## Contexte

Le code legacy s’appuyait sur globales, `include_spip()` et `service()` peu typés.
Le conteneur permet classes testables, listeners et tâches cron par attributs.

## Pourquoi utiliser les services ?

- Modularité et tests unitaires (mock des dépendances).
- Découverte automatique des listeners, tâches cron, règles Guard, etc.
- Alignement avec l’écosystème Symfony.

## Fonctionnement

- Chaque plugin peut fournir `config/services.php`.
- `autowire()` et `autoconfigure()` activent l’injection et les tags SPIP.
- Les paramètres du projet (`spip.dirs.*`, `spip.logger.*`, …) sont disponibles via `%spip...%`.

## Limites et pièges

### Plugins Composer vs SVP

1. **Plugins dans le `composer.json` racine** : dépendances Composer complètes.
2. **Plugins activés via SVP** : autoload PSR-4 du plugin uniquement ; pas d’installation automatique des `require` du plugin.

Pour des bibliothèques tierces sans Composer racine, prévoir un `vendor/` embarqué ou éviter les conflits de namespaces.

## Voir aussi

- [Configurer les services d’un plugin](../upgrade/services-plugin.md)
- [Façade Spip et Inputs](acces-services-spip.md)
