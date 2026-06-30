# Configurer les services d’un plugin

Le conteneur Symfony s’active dans un plugin via `config/services.php` (autowiring, autoconfigure).
Le modèle est expliqué dans [Services et injection de dépendances](../features/services-symfony.md).

## Objectif

Enregistrer les classes du plugin comme services pour l’injection de dépendances
et l’autoconfiguration (`AsPipelineListener`, `AsCronTask`, etc.).

## Prérequis

- Plugin SPIP 5.0 avec autoload PSR-4 (`composer.json` du plugin ou section SVP).
- Namespace cohérent (ex. `SpipContrib\Plugin\MonPlugin\`).

## Étapes

### 1. Créer `config/services.php`

```php
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

```php
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

- Après modification de `config/services.php`, invalider le cache boot (`bin/spip cache:warmup --clear`) ou activer/désactiver un plugin pour
  recalculer la signature du manifeste. Voir [Plugins et conteneur](../features/plugins-et-conteneur.md).
- Injecter un service du plugin dans un listener et confirmer qu’il est résolu au runtime.

## Voir aussi

- [Services et injection de dépendances](../features/services-symfony.md)
- [Façade Spip — usage procédural](acces-services-spip.md)
- [Plugins et conteneur](../features/plugins-et-conteneur.md)
