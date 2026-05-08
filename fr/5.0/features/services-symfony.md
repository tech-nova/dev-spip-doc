# Services et Injection de dépendances

SPIP 5.0 intègre le **Conteneur de Services de Symfony**, permettant une gestion moderne des dépendances au sein des plugins.

## Pourquoi utiliser les services ?

L'injection de dépendances permet de créer un code plus modulaire et plus facile à tester. Au lieu d'utiliser des globales ou des fonctions `include_spip()`, vous recevez les objets dont vous avez besoin directement dans le constructeur de vos classes.

## Configurer son plugin

Pour que SPIP reconnaisse vos classes comme des services, vous devez créer un fichier `config/services.php` à la racine de votre plugin.

### Exemple de `config/services.php`

```php
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;

return static function (ContainerConfigurator $container): void {
    $services = $container->services()
        ->defaults()
        ->autowire()      // Injection automatique
        ->autoconfigure();  // Configuration automatique (attributs)

    // Chargement des classes du plugin
    $services->load('SpipContrib\\Plugin\\MonPlugin\\', '../src/');
};
```

## Autowiring et Autoconfiguration

- **Autowiring :** Le conteneur devine automatiquement quels services injecter dans votre constructeur en se basant sur le typage des arguments.
- **Autoconfiguration :** Les classes utilisant des attributs comme `#[AsPipelineListener]` ou `#[AsCronTask]` sont automatiquement détectées et enregistrées avec les bons tags.

## Utilisation des paramètres SPIP

Vous pouvez accéder aux paramètres de configuration de SPIP (préfixés par `spip.`) directement dans vos configurations de services.

```php
$services->set(MonService::class)
    ->arg('$cacheDir', '%spip.dirs.tmp%cache/');
```

## Accès manuel au conteneur (Legacy Bridge)

Si vous devez accéder à un service depuis un code legacy (squelette ou fonction PHP classique), vous pouvez utiliser la fonction `app()` :

```php
use function SpipLeague\Component\Kernel\app;

$monService = app()->getContainer()->get(MonService::class);
```
*Note : Privilégiez toujours l'injection de dépendances dans vos nouvelles classes.*

## Limitations et dépendances externes

Il est important de distinguer deux modes d'activation des plugins dans SPIP 5.0, car ils impactent la gestion des dépendances :

1. **Plugins installés via Composer** (ex: les `plugins-dist/` ou les plugins ajoutés au `composer.json` racine) : Ils bénéficient de la gestion complète de Composer. Leurs dépendances sont téléchargées et disponibles globalement.
2. **Plugins activés via l'interface (SVP)** : Pour ces plugins, SPIP assure un support d'autoloading spécifique mais limité.

### Cas des plugins activés via SVP
Si votre plugin n'est pas déclaré dans le `composer.json` racine du projet :
- SPIP analyse uniquement la section `autoload.psr-4` de votre plugin pour charger vos propres classes.
- Il ne procède **pas** à l'installation des dépendances listées dans la section `require` de votre plugin.
- L'ensemble des classes découvertes est agrégé dans un fichier de cache (`tmp/cache/boot/classmap.php`).

**Conséquence :** Si votre plugin nécessite des bibliothèques PHP tierces, SPIP ne pourra pas les récupérer automatiquement. Vous devrez alors user de stratégies alternatives, comme embarquer un répertoire `vendor/` pré-calculé au sein de votre plugin et charger manuellement son autoloader, en veillant à éviter les conflits de noms (via le préfixage de namespaces par exemple).
