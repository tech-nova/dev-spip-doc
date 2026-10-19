# Migration des pipelines dans les plugins

Dans un plugin, les fonctions `prefixe_nom_pipeline()` sont remplacées par des listeners modernes déclarés en services.
Le modèle est expliqué dans [Event Dispatcher et Pipelines](../features/event-dispatcher-et-pipelines.md).

## Vue d'ensemble

Avant SPIP 5.0, un plugin déclarait généralement un pipeline dans `paquet.xml`, puis exposait une fonction globale.
En SPIP 5.0, la logique métier peut vivre dans une classe dédiée, avec une méthode `onNomEvenement()` déclarée comme listener.

Pendant la transition, les deux modèles peuvent cohabiter : les fonctions legacy continuent d'être appelées,
tandis que les nouveaux listeners passent par le dispatcher Symfony.

## Déclaration dans `config/services.php`

Pour que SPIP détecte les listeners avec attributs et puisse injecter leurs dépendances, le plugin doit déclarer ses services dans `config/services.php`.

Avec `autoconfigure()`, les méthodes annotées avec `#[AsPipelineListener]` sont enregistrées automatiquement.

```php
<?php
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;

return static function (ContainerConfigurator $container): void {
    $services = $container->services()
        ->defaults()
        ->autowire()
        ->autoconfigure();

    $services->load('MonPlugin\\', '../src/');
};
```

Voir aussi [Services et injection de dépendances](../features/services-symfony.md).

## Exemple simple : HTML final

Avant :

```php
function monplugin_affichage_final(string $html): string {
    return str_replace('</body>', '<script src="/js/monplugin.js"></script></body>', $html);
}
```

Après :

```php
namespace MonPlugin\Pipeline\Listener;

use Spip\Framework\Pipeline\Event\AffichageFinalEvent;
use SpipLeague\Bridge\Pipeline\Attribute\AsPipelineListener;

final class AffichageFinalListener
{
    #[AsPipelineListener]
    public function onAffichageFinal(AffichageFinalEvent $event): void
    {
        $event->appendToBody('<script src="/js/monplugin.js"></script>');
    }
}
```

L'attribut n'a pas besoin d'argument parce que `AffichageFinalEvent` indique déjà le pipeline correspondant.

## Flux structuré `args` / `data`

Avant :

```php
function monplugin_pre_edition(array $flux): array {
    $id = (int) ($flux['args']['id_objet'] ?? 0);
    $flux['data']['maj'] = date('Y-m-d H:i:s');

    return $flux;
}
```

Après, si un event dédié existe :

```php
namespace MonPlugin\Pipeline\Listener;

use Spip\Framework\Pipeline\Event\PreEditionEvent;
use SpipLeague\Bridge\Pipeline\Attribute\AsPipelineListener;

final class PreEditionListener
{
    #[AsPipelineListener]
    public function onPreEdition(PreEditionEvent $event): void
    {
        if ($event->getSqlTable() !== 'spip_articles') {
            return;
        }

        $event->setField('maj', date('Y-m-d H:i:s'));
    }
}
```

`PreEditionEvent` et `PostEditionEvent` exposent le contexte de l'édition (`getSqlTable()`, `getObjet()`, `getIdObjet()`,
`getAction()`, `getChampsAnciens()`…) et les méthodes `getField()`, `setField()`, `getFields()` et `setFields()`.
Le `subject` contient les champs à enregistrer pour `PreEditionEvent`, et les champs déjà traités pour `PostEditionEvent`.

Si le pipeline n'a pas encore d'event dédié, utilisez `PipelineEvent` avec un nom explicite :

```php
namespace MonPlugin\Pipeline\Listener;

use SpipLeague\Bridge\Pipeline\PipelineEvent;
use SpipLeague\Bridge\Pipeline\Attribute\AsPipelineListener;

final class PipelineNonTypeListener
{
    #[AsPipelineListener('pipeline_non_type')]
    public function onPipelineNonType(PipelineEvent $event): void
    {
        $data = $event->getSubject();
        $id = (int) $event->getArgument('id_article', 0);

        if (\is_string($data)) {
            $event->setSubject($data . " - article $id");
        }
    }
}
```

Les arguments représentent le contexte de l'appel. Ils sont consultables via `getArguments()` ou `getArgument()`, mais la donnée principale à modifier est le `subject`.

## Autoload du plugin

Les plugins distribués avec SPIP bénéficient normalement de l'autoloading déclaré dans le dépôt.
Pour un plugin installé via le backoffice, le collecteur d'autoload détecte le `composer.json` du plugin et enregistre ses mappings PSR-4.

Pour un plugin installé via SVP, déclarez au minimum un autoload PSR-4 dans le `composer.json` du plugin :

```json
{
  "autoload": {
    "psr-4": {
      "MonPlugin\\": "src/"
    }
  }
}
```

## Injection de dépendances

Un listener est un service du conteneur. Il peut donc recevoir ses dépendances par constructeur dès lors qu'il est chargé par `config/services.php`.

```php
namespace MonPlugin\Pipeline\Listener;

use Psr\Log\LoggerInterface;
use SpipLeague\Bridge\Pipeline\PipelineEvent;
use SpipLeague\Bridge\Pipeline\Attribute\AsPipelineListener;

final class ConfigMetasListener
{
    public function __construct(
        private readonly LoggerInterface $logger,
    ) {
    }

    #[AsPipelineListener('configurer_liste_metas')]
    public function onConfigurerListeMetas(PipelineEvent $event): void
    {
        $metas = $event->getSubject();
        if (!\is_array($metas)) {
            return;
        }

        $metas['ma_cle'] = 'oui';
        $event->setSubject($metas);

        $this->logger->info('Configuration des metas du plugin.');
    }
}
```

## Tests unitaires

Un listener est une classe PHP standard. Pour le tester, instanciez l'event, appelez la méthode listener, puis vérifiez l'état de l'event.

```php
use MonPlugin\Pipeline\Listener\AffichageFinalListener;
use PHPUnit\Framework\TestCase;
use Spip\Framework\Pipeline\Event\AffichageFinalEvent;

final class AffichageFinalListenerTest extends TestCase
{
    public function testAjouteLeScript(): void
    {
        $event = new AffichageFinalEvent('<html><body></body></html>');

        (new AffichageFinalListener())->onAffichageFinal($event);

        self::assertStringContainsString('/js/monplugin.js', $event->getHtml());
    }
}
```

Pour tester l'intégration complète, construisez un conteneur de test, enregistrez les listeners ou services, puis vérifiez le comportement via le dispatcher de pipelines.

## Cohabitation ancien / nouveau

- Si du code tiers appelle encore une fonction globale de pipeline, conservez une fonction minimale qui délègue à un listener.
- Les listeners modernes déclarés via attributs n'ont pas besoin d'entrée `<pipeline>` dans `paquet.xml`.
- Conservez les déclarations `<pipeline>` uniquement pour les fonctions legacy qui doivent encore être appelées par ce mécanisme.
- Déplacez la logique métier dans les classes listeners : cela simplifie les tests **et prépare l'injection de services**.

## Voir aussi

- [Event Dispatcher et Pipelines](../features/event-dispatcher-et-pipelines.md)
- [Migrer les pipelines](migration/pipelines.md)
- [Événements de pipelines](../reference/evenements-pipelines.md)
- [Référence `AsPipelineListener`](../reference/as-pipeline-listener.md)
