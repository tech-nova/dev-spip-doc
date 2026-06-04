# Migration des pipelines

Ce guide pratique décrit **comment** migrer les appels et listeners de pipelines vers l'Event Dispatcher de SPIP 5.0.
Le modèle est expliqué dans [Event Dispatcher et Pipelines](../features/event-dispatcher-et-pipelines.md).

SPIP 5.0 fait passer l'exécution des pipelines par l'`EventDispatcher` Symfony.
La fonction historique `pipeline()` reste le point d'entrée public, mais elle délègue désormais à un dispatcher de pipelines
et transporte les données dans des objets Event.

Cette page décrit la migration générale des appels et listeners.
Pour les recettes propres aux plugins, consultez [Migrer les pipelines d'un plugin](pipelines-plugins.md).

## Ce qui change

- Les listeners modernes sont des méthodes de services, déclarées avec `#[AsPipelineListener]` ou via la configuration du plugin.
- Les classes d'events dédiées du noyau, comme `AffichageFinalEvent`, `InsertHeadEvent` ou `FormulaireVerifierEvent`,
  remplacent progressivement les payloads manipulés à la main.
- Les pipelines qui n'ont pas encore d'event dédié passent par `SpipLeague\Bridge\Pipeline\PipelineEvent`.
- Les anciens caches de pipelines générés ne sont plus utilisés au runtime.

## API `pipeline()`

Le mode legacy reste accepté :

```php
$html = pipeline('affichage_final', $html);
```

Pour un pipeline structuré, l'ancienne forme `['args' => ..., 'data' => ...]` reste comprise :

```php
$champs = pipeline('pre_edition', ['args' => ['table' => 'spip_articles'], 'data' => $champs]);
```

En SPIP 5.0, préférez la forme à trois arguments, plus lisible :

```php
$champs = pipeline('pre_edition', $champs, ['table' => 'spip_articles', 'id_objet' => 12]);
```

Si le pipeline doit rester structuré avec un contexte vide, passez explicitement `[]` en troisième argument :

```php
$data = pipeline('mon_pipeline', $data, []);
```

Quand un event dédié existe, la forme recommandée consiste à instancier l'event, à appeler `pipeline($event)`, puis à relire les données typées :

```php
use Spip\Framework\Pipeline\Event\AffichageFinalEvent;

$event = new AffichageFinalEvent($html);
pipeline($event);
$html = $event->getHtml();
```

Pour un pipeline non encore typé :

```php
use SpipLeague\Bridge\Pipeline\PipelineEvent;

$event = new PipelineEvent('mon_pipeline', $data, ['id' => 12]);
pipeline($event);
$data = $event->getSubject();
```

## Migration des listeners

Les anciennes fonctions de pipeline peuvent être remplacées progressivement par des méthodes de service.

Avant :

```php
function monplugin_affichage_final(string $html): string {
    return str_replace('</body>', '<script src="/js/plugin.js"></script></body>', $html);
}
```

Après, avec un event spécifique :

Quand l'argument de la méthode est un event spécifique, n'indiquez pas le nom du pipeline :
SPIP le déduit depuis l'attribut `#[AsPipelineEvent]` porté par la classe d'event.

```php
use Spip\Framework\Pipeline\Event\AffichageFinalEvent;
use SpipLeague\Component\Kernel\Attribute\AsPipelineListener;

final class FooterListener
{
    #[AsPipelineListener]
    public function onAffichageFinal(AffichageFinalEvent $event): void
    {
        $event->appendToBody('<script src="/js/plugin.js"></script>');
    }
}
```

Avec `PipelineEvent`, la déduction est impossible : il faut déclarer explicitement le pipeline.

```php
use SpipLeague\Bridge\Pipeline\PipelineEvent;
use SpipLeague\Component\Kernel\Attribute\AsPipelineListener;

final class LegacyPipelineListener
{
    #[AsPipelineListener('mon_pipeline')]
    public function onMonPipeline(PipelineEvent $event): void
    {
        $subject = $event->getSubject();
        $arguments = $event->getArguments();

        $event->setSubject($subject);
    }
}
```

## Migration des appels

Un appel legacy peut rester inchangé pendant la transition :

```php
$html = pipeline('affichage_final', $html);
```

Quand le code appelant a accès à une classe d'event dédiée, il peut basculer vers l'appel typé :

```php
$event = new AffichageFinalEvent($html);
pipeline($event);
$html = $event->getHtml();
```

Cette forme rend explicite le type de données transporté et évite de manipuler manuellement les tableaux `args` / `data`.

## Services du conteneur

Le noyau expose le dispatcher Symfony et le dispatcher de pipelines :

- `event_dispatcher` : instance de `Symfony\Component\EventDispatcher\EventDispatcher`.
- `spip.pipeline_dispatcher` : dispatcher spécialisé pour les pipelines SPIP.

Pour un service déclaré explicitement, l'enregistrement peut cibler une méthode nommée :

```php
$registry->registerService('mon_pipeline', 'mon_service_id', 'onMonPipeline');
```

## Points d'attention

- Le cache `charger_pipelines.php` n'est plus généré ni chargé pour l'exécution des pipelines.
- Les fonctions `execute_pipeline_*` ne sont plus générées.
- `$GLOBALS['spip_pipeline']` et `$GLOBALS['spip_matrice']` ne sont plus la source runtime de l'exécution.
- La constante `_CACHE_PIPELINES` a été supprimée.

## Voir aussi

- [Event Dispatcher et Pipelines](../features/event-dispatcher-et-pipelines.md) — modèle et concepts
- [Migrer les pipelines d'un plugin](pipelines-plugins.md)
- [Événements de pipelines](../reference/evenements-pipelines.md)
- [Référence `AsPipelineListener`](../reference/as-pipeline-listener.md)
