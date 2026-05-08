# Tâches Cron et Attributs

Dans SPIP 5.0, la déclaration des tâches de fond (génie) est simplifiée grâce à l'utilisation d'attributs PHP.

## L'attribut `#[AsCronTask]`

Cet attribut peut être placé soit sur une **classe** (utilisant alors la méthode `__invoke()`), soit directement sur une **méthode** spécifique d'un service.

### Exemple 1 : Sur une classe (méthode `__invoke`)

```php-inline
namespace SpipContrib\Plugin\MonPlugin\Cron\Task;

use SpipLeague\Component\Kernel\Attribute\AsCronTask;

#[AsCronTask(name: 'monplugin_nettoyage', periode: 3600)]
final class NettoyageTask
{
    public function __invoke(): int
    {
        // logique...
        return 0; // Succès
    }
}
```

### Exemple 2 : Sur une méthode spécifique

C'est utile si vous souhaitez regrouper plusieurs tâches au sein d'un même service.

```php-inline
namespace SpipContrib\Plugin\MonPlugin\Service;

use SpipLeague\Component\Kernel\Attribute\AsCronTask;

final class MaintenanceService
{
    #[AsCronTask(name: 'monplugin_raz', periode: 86400)]
    public function remiseAZero(): int
    {
        // logique...
        return 0;
    }

    #[AsCronTask(name: 'monplugin_optimise', periode: 3600)]
    public function optimiser(): int
    {
        // logique...
        return 0;
    }
}
```

## Paramètres de l'attribut

| Paramètre | Description |
| :--- | :--- |
| `name` | Nom unique de la tâche (requis). |
| `periode` | Période d'exécution en secondes (requis, min 60). |
| `priorite` | Priorité d'exécution (optionnel, défaut 0). |

## Codes de retour
Attention, la convention des codes de retour change entre le système legacy et le système moderne :
- **Legacy :** `>= 0` pour le succès.
- **Moderne (Unix) :** `0` pour le succès, `> 0` pour une erreur.

## Avantages
- **Organisation :** Les tâches sont regroupées dans `src/Cron/Task/`.
- **Injection :** Vous pouvez injecter des services (base de données, logger, API) directement dans le constructeur de votre tâche.
- **Plus de `paquet.xml` :** La déclaration est portée par le code lui-même.

## Prérequis
Comme pour les listeners, vos classes de tâches doivent être enregistrées comme services via un fichier `config/services.php` dans votre plugin.
