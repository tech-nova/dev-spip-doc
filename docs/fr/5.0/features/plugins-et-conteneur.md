# Plugins et conteneur de services

Les plugins actifs de SPIP 5.0 **contribuent** au conteneur Symfony
(services, listeners, tâches cron, autoload PSR-4).
Le paquet **`spip-league/plugin-manager`** gère le manifeste des plugins actifs,
la lecture de `paquet.xml` et la **compilation** du conteneur complet avant le traitement HTTP.

Mise en œuvre des services dans un plugin : [Configurer les services d'un plugin](../guides/services-plugin.md).

## Usage typique

Le manifeste des plugins actifs est persisté dans `var/state/plugins.php`
(approximativement équivalent de `config/bundles.php` en Symfony) :

```php
return [
    'signature' => 'a1b2c3…',
    'paths' => [
        'ecrire/',
        'prive/',
        'squelettes-dist/',
        'plugins-dist/spip/mots/',
    ],
];
```

La `signature` reflète l'ordre et l'ensemble des chemins : toute activation ou désactivation de plugin la
recalcule et déclenche une recompilation du conteneur **au prochain hit**.

## Fonctionnement

- **`spip-league/kernel`** expose les interfaces (`PluginListProviderInterface`, `ContainerCompilerInterface`)
  et orchestre le boot via `ContainerBootstrap`, sans dépendre en dur du paquet plugin-manager.
- **`spip-league/plugin-manager`** implémente manifeste, découverte, collectors (`config/services.php`,
  autoload, menus…) et `DeclarativeContainerCompiler`.
- **`spip/framework`** conserve la glue legacy des pipelines (`PluginPipelineCollector`, registrars historiques)
  consommée par le compilateur quand le framework est présent.

Le conteneur servi à une requête est figé au pré-boot
(`Kernel::boot()` → `ContainerBootstrap::loadOrFallback()`), **avant** `SpipHttpKernel::handle()`.

## Artefacts boot

En plus du dump compilé (`tmp/cache/boot/container.prod.php`), le plugin-manager génère des artefacts
dans `tmp/cache/boot/` (chemins, options agrégées, etc.). Le runtime HTTP charge ensuite les `options.php`
des plugins via `BootOrchestrator` (`spip/framework`), après `spip_initialisation_core()`.

## Limites actuelles

- Les fichiers `options.php` restent exécutés au **runtime** HTTP (hors conteneur Symfony) :
  certaines déclarations dedans ne sont plus possible ("surcharge" de constante, écritures de globales pipeline...), ces éléments étant figés avant le traitement de la requête.
- La meta SQL `plugin` reste un miroir admin ; la source du boot est le manifeste fichier.

## Voir aussi

- [Services et injection de dépendances](services-symfony.md)
- [Configurer les services d'un plugin](../guides/services-plugin.md)
- [Cycle applicatif HTTP](../architecture/cycle-applicatif-http.md)
- [Dépôts spip-league](../architecture/depots-spip-league.md)
- [Manifeste des plugins actifs](../reference/manifeste-plugins.md)
