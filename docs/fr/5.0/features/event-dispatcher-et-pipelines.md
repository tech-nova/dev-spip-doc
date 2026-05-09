# Event Dispatcher et Pipelines

SPIP 5.0 modernise son système de pipelines en s'appuyant sur le composant **EventDispatcher** de Symfony. Cette approche permet d'utiliser des événements typés et des listeners enregistrés comme services.

## Concepts clés

- **Event :** Une classe PHP qui transporte les données du pipeline. Chaque pipeline majeur possède sa propre classe d'événement (ex: `AffichageFinalEvent`).
- **Listener :** Une méthode dans une classe service qui réagit à un événement.
- **Attribut `#[AsPipelineListener]` :** Utilisé pour déclarer une méthode comme étant un listener de pipeline.

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
    public function __invoke(AffichageFinalEvent $event): void
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
