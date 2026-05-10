# Event Dispatcher et Pipelines

SPIP 5.0 modernise son système de pipelines en s'appuyant sur le composant **EventDispatcher** de Symfony. Cette approche permet d'utiliser des événements typés
et des listeners enregistrés comme services.

## Concepts clés

- **Event :** Une classe PHP qui transporte les données du pipeline. Chaque pipeline majeur possède sa propre classe d'événement (ex: `AffichageFinalEvent`).
- **Listener :** Une méthode dans une classe service qui réagit à un événement.
- **Attribut `#[AsPipelineListener]` :** Utilisé pour déclarer une méthode comme étant un listener de pipeline.

## `AsPipelineListener` : mode explicite et déduction automatique

L'attribut `#[AsPipelineListener]` supporte deux styles :

- **Mode explicite** : on indique le nom du pipeline ;
- **Mode déduit** : on n'indique pas de pipeline, il est déduit depuis le type du 1er argument de la méthode listener.

Recommandation : préférer des méthodes nommées `onNomPipeline(...)` (ex. `onAffichageFinal(...)`) plutôt que `__invoke`, pour améliorer la lisibilité et la cohérence événementielle.

Quand l'attribut est posé sur la classe, la méthode appelée par défaut est `__invoke`.
Comme Symfony, vous pouvez aussi poser `#[AsPipelineListener]` directement sur une méthode.

### 1) Mode explicite (historique)

Ce mode reste utile (et recommandé) quand un pipeline ne dispose pas encore d'une classe d'event typée dédiée.
Dans ce cas, on utilise `PipelineEvent` et on indique explicitement le nom du pipeline.

```php-inline
use Spip\Framework\Pipeline\Event\AffichageFinalEvent;
use SpipLeague\Component\Kernel\Attribute\AsPipelineListener;

final class FooterListener
{
    #[AsPipelineListener('affichage_final')]
    public function onAffichageFinal(AffichageFinalEvent $event): void
    {
        $event->appendToBody('<!-- footer -->');
    }
}
```

Exemple avec event générique :

```php-inline
use SpipLeague\Bridge\Pipeline\PipelineEvent;
use SpipLeague\Component\Kernel\Attribute\AsPipelineListener;

final class LegacyPipelineListener
{
    #[AsPipelineListener('pipeline_non_type')]
    public function onPipelineNonType(PipelineEvent $event): void
    {
        $subject = $event->getSubject();
        $args = $event->getArguments();
        // ...
        $event->setSubject($subject);
    }
}
```

### 2) Mode déduit (recommandé quand un event typé existe)

Si l'attribut est utilisé sans argument, SPIP déduit le pipeline à partir de la classe de l'événement typée en premier argument.

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

La classe d'event doit être annotée avec `#[AsPipelineEvent('nom_pipeline')]` (c'est le cas des events du cœur SPIP).
Le type générique `PipelineEvent` ne permet pas cette déduction (puisqu'il ne porte pas d'identifiant de pipeline unique).

### 3) `union types` (plusieurs pipelines)

Comme avec Symfony pour `AsEventListener`, un listener peut écouter plusieurs événements typés via un type union :

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

### 4) Position d'exécution

`AsPipelineListener` supporte l'option `position` :

- `prepend` (priorité haute),
- `normal` (valeur par défaut),
- `append` (priorité basse).

```php-inline
#[AsPipelineListener(position: 'prepend')]
public function __invoke(AffichageFinalEvent $event): void
{
    // exécuté tôt dans la chaîne
}
```

### 5) Cas d'erreur (compilation du conteneur)

Sans pipeline explicite, SPIP déclenche une erreur si la déduction est impossible :

- pas de type sur le 1er argument ;
- type scalaire/builtin ;
- type d'event sans attribut `AsPipelineEvent`.

## Migration des pipelines historiques

Le système moderne remplace les déclarations `<pipeline>` dans `paquet.xml` et les fonctions `prefixe_nom_pipeline()`.

### Exemple : Migration de `affichage_final`

**Avant (paquet.xml + PHP) :**

```xml
<pipeline nom="affichage_final" inclure="monplugin_pipelines.php" />
```

```php-inline
function monplugin_affichage_final($texte) {
    return $texte . "<!-- mon pied de page -->";
}
```

**Après (Listener moderne) :**

```php-inline
namespace SpipContrib\Plugin\MonPlugin\Pipeline\Listener;

use Spip\Framework\Pipeline\Event\AffichageFinalEvent;
use SpipLeague\Component\Kernel\Attribute\AsPipelineListener;

final class AffichageFinalListener
{
    #[AsPipelineListener('affichage_final')]
    public function onAffichageFinal(AffichageFinalEvent $event): void
    {
        $event->appendToBody("<!-- mon pied de page -->");
    }
}
```

## Migration des assets (Head Assets)

Les balises `<style>` et `<script>` de `paquet.xml` doivent également être migrées vers des listeners.

| Type d'asset | Pipeline | Event dédié |
| :--- | :--- | :--- |
| CSS Public | `insert_head_css` | `InsertHeadCssEvent` |
| JS Public | `insert_head` | `InsertHeadEvent` |

### Exemple d'injection CSS

```php-inline
#[AsPipelineListener('insert_head_css')]
public function onInsertHeadCss(InsertHeadCssEvent $event): void
{
    $event->addStylesheet(find_in_path('css/monplugin.css'));
}
```

## Avantages de l'approche moderne

1. **Découvrabilité :** Les listeners sont dans des classes dédiées.
2. **Typage fort :** Autocomplétion dans l'IDE grâce aux classes Event.
3. **Injection de dépendances :** Vos listeners peuvent recevoir des services via leur constructeur.
4. **Testabilité :** Les listeners sont des classes PHP standards, faciles à tester unitairement.

## Prérequis

Pour que vos listeners soient détectés, votre plugin doit :

1. Avoir un autoloading PSR-4 configuré dans `composer.json`.
2. Avoir un fichier `config/services.php` qui charge vos services (voir [Services et Injection de dépendances](services-symfony.md)).
