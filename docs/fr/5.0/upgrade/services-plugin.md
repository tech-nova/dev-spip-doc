# Configurer les services d’un plugin

Ce guide pratique décrit **comment** activer le conteneur Symfony dans un plugin SPIP 5.0 (`config/services.php`, autowiring).

## Objectif

Enregistrer les classes du plugin comme services pour l’injection de dépendances
et l’autoconfiguration (`AsPipelineListener`, `AsCronTask`, etc.).

## Prérequis

- Plugin SPIP 5.0 avec autoload PSR-4 (`composer.json` du plugin ou section SVP).
- Namespace cohérent (ex. `SpipContrib\Plugin\MonPlugin\`).

## Étapes

### 1. Créer `config/services.php`

```php-inline
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;

return static function (ContainerConfigurator $container): void {
    $services = $container->services()
        ->defaults()
        ->autowire()
        ->autoconfigure();

    $services->load('SpipContrib\\Plugin\\MonPlugin\\', '../src/');
};
```

### 2. Utiliser les paramètres SPIP

```php-inline
$services->set(MonService::class)
    ->arg('$cacheDir', '%spip.dirs.tmp%cache/');
```

### 3. Vérifier l’autoconfiguration

Les attributs `#[AsPipelineListener]`, `#[AsCronTask]`, `#[AsGuard]`, etc. sont détectés automatiquement si la classe est chargée comme service.

## Cas particuliers

### Plugins activés via SVP (sans Composer racine)

- Seul l’autoload PSR-4 du plugin est pris en charge.
- Les dépendances `require` du plugin ne sont **pas** installées automatiquement : prévoir un `vendor/` embarqué ou déclarer le plugin dans le `composer.json` racine.

## Vérification

- Vider le cache (`tmp/cache/`) après modification de `services.php`.
- Injecter un service du plugin dans un listener et confirmer qu’il est résolu au runtime.

## Voir aussi

- [Services et injection de dépendances](../features/services-symfony.md)
- [Façade Spip — usage procédural](acces-services-spip.md)
