# Event Dispatcher et Pipelines

Les pipelines SPIP — ces points fixes où les plugins interceptent des données du cycle de publication —
reposent en SPIP 5.0 sur l'**Event Dispatcher** de Symfony : événements typés, listeners déclarés en services,
et un pont qui garde la fonction `pipeline()` compatible.

Mise en œuvre dans un plugin : [Pipelines dans un plugin](../guides/pipelines-plugins.md).

## Usage typique

Un listener est une méthode de service annotée. Quand l'argument est un event dédié, le pipeline est déduit du type :

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

## Contexte

Le modèle historique reposait sur des fonctions globales et `pipelines.php`, avec des données souvent non typées.
SPIP 5.0 conserve ce mécanisme tout en offrant une couche typée et testable.

## Concepts clés

- **Event :** classe PHP qui transporte les données du pipeline (ex. `AffichageFinalEvent`).
- **Listener :** méthode de service qui réagit à un event, déclarée via `#[AsPipelineListener]`.
- **Event générique :** `PipelineEvent` pour les pipelines sans classe dédiée encore.

La déduction du nom de pipeline depuis le type d’event (`#[AsPipelineEvent('nom')]`) évite les erreurs.
Les unions de types permettent d’écouter plusieurs pipelines avec un seul listener.

## Fonctionnement

Le conteneur enregistre les listeners au boot des plugins.
L’ordre d’exécution se règle avec `position` (`prepend`, `normal`, `append`).
Les données passent par l’objet event plutôt que par des tableaux non typés.

## Différences avec SPIP 4.x

| SPIP 4.x | SPIP 5.0 |
|----------|----------|
| `prefixe_pipeline()` dans le plugin | Listener + `#[AsPipelineListener]` |
| `pipeline('nom', $data)` | Event Dispatcher + classes d’event |
| Données souvent non typées | Typage fort sur les events du cœur |

## Limites et pièges

- Ne pas confondre **pipeline historique** et **listener Symfony** dans la terminologie.
- Les pipelines sans classe dédiée restent sur `PipelineEvent` : le nom doit être indiqué explicitement sur l’attribut.
- La procédure de déclaration et de migration est détaillée dans les guides, pas ici.

## Voir aussi

- [Pipelines dans un plugin](../guides/pipelines-plugins.md)
- [Migrer les pipelines](../guides/migration/pipelines.md)
- [Événements de pipelines](../reference/evenements-pipelines.md)
- [Référence `AsPipelineListener`](../reference/as-pipeline-listener.md)
