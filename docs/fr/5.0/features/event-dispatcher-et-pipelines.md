# Event Dispatcher et Pipelines

SPIP 5.0 modernise son système de pipelines en s'appuyant sur le composant **EventDispatcher** de Symfony.
Les pipelines historiques restent disponibles, mais ils peuvent maintenant être manipulés avec des events typés et des listeners enregistrés comme services.

Cette page présente le modèle général. Pour migrer du code existant, consultez [Migrer les pipelines](../upgrade/pipelines.md).
Pour la liste des events disponibles, consultez [Événements de pipelines](../reference/evenements-pipelines.md).

## Concepts clés

- **Event :** une classe PHP qui transporte les données du pipeline. Les pipelines majeurs disposent d'une classe dédiée, par exemple `AffichageFinalEvent`.
- **Listener :** une méthode de service qui réagit à un event.
- **Attribut `#[AsPipelineListener]` :** la déclaration d'une méthode comme listener de pipeline.
- **Event générique :** `PipelineEvent` reste disponible pour les pipelines qui n'ont pas encore de classe dédiée.

## Déclaration des listeners

La convention recommandée est de poser `#[AsPipelineListener]` directement sur une méthode nommée `onNomEvenement(...)`.

Quand une classe d'event dédiée existe, le nom du pipeline est déduit depuis le type de l'argument :

```php-inline
use Spip\Framework\Pipeline\Event\AffichageFinalEvent;
use SpipLeague\Component\Kernel\Attribute\AsPipelineListener;

final class FooterListener
{
    #[AsPipelineListener]
    public function onAffichageFinal(AffichageFinalEvent $event): void
    {
        $event->appendToBody('<!-- footer -->');
    }
}
```

Pour un pipeline non encore typé, utilisez `PipelineEvent` et indiquez explicitement le nom du pipeline :

```php-inline
use SpipLeague\Bridge\Pipeline\PipelineEvent;
use SpipLeague\Component\Kernel\Attribute\AsPipelineListener;

final class LegacyPipelineListener
{
    #[AsPipelineListener('pipeline_non_type')]
    public function onPipelineNonType(PipelineEvent $event): void
    {
        $subject = $event->getSubject();
        // ...
        $event->setSubject($subject);
    }
}
```

La classe d'event doit être annotée avec `#[AsPipelineEvent('nom_pipeline')]` pour permettre la déduction.
C'est le cas des events du cœur SPIP. Le type générique `PipelineEvent` ne permet pas cette déduction, puisqu'il ne correspond pas à un pipeline unique.

## Plusieurs pipelines

Un listener peut écouter plusieurs events typés via un type union :

```php-inline
use Spip\Framework\Pipeline\Event\AfficheDroiteEvent;
use Spip\Framework\Pipeline\Event\AfficheGaucheEvent;
use SpipLeague\Component\Kernel\Attribute\AsPipelineListener;

final class SidebarListener
{
    #[AsPipelineListener]
    public function onSidebar(AfficheDroiteEvent|AfficheGaucheEvent $event): void
    {
        // Le listener est enregistré sur les 2 pipelines
    }
}
```

## Position d'exécution

`AsPipelineListener` supporte l'option `position` :

- `prepend` (priorité haute),
- `normal` (valeur par défaut),
- `append` (priorité basse).

```php-inline
#[AsPipelineListener(position: 'prepend')]
public function onAffichageFinal(AffichageFinalEvent $event): void
{
    // Exécuté tôt dans la chaîne
}
```

## Avantages

Le modèle moderne apporte :

- une meilleure découvrabilité des extensions ;
- un typage fort des données transportées ;
- l'injection de dépendances dans les listeners ;
- des tests unitaires plus simples.

## Où aller ensuite ?

- [Migrer les pipelines](../upgrade/pipelines.md) : parcours de migration depuis les appels et fonctions legacy.
- [Migrer les pipelines d'un plugin](../upgrade/pipelines-plugins.md) : recettes pour `config/services.php`, autoload et tests.
- [Événements de pipelines](../reference/evenements-pipelines.md) : liste des events disponibles et méthodes utiles.
- [Référence `AsPipelineListener`](../reference/as-pipeline-listener.md) : signature, résolution, positions et erreurs.
