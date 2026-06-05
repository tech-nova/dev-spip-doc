# Services et injection de dépendances

SPIP 5.0 intègre le **conteneur de services Symfony** : autowiring, autoconfiguration des attributs
(listeners, tâches cron, règles Guard…) et paramètres `spip.*` injectables.
Chaque plugin peut fournir un fichier `config/services.php` pour enregistrer ses classes comme services.

Configuration dans un plugin : [Configurer les services d’un plugin](../guides/services-plugin.md).

## Usage typique

```php
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;

return static function (ContainerConfigurator $container): void {
    $container->services()
        ->defaults()
            ->autowire()
            ->autoconfigure()
        ->load('MonPlugin\\', '../src/');
};
```

## Pourquoi utiliser les services ?

- Modularité et tests unitaires (mock des dépendances).
- Découverte automatique des listeners, tâches cron, règles Guard, etc.
- Injection de dépendance automatisée.
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

- [Configurer les services d’un plugin](../guides/services-plugin.md)
- [Façade Spip et Inputs](acces-services-spip.md)
