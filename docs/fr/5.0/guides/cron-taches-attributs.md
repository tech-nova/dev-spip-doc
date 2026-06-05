# Migrer les tâches cron

Les tâches de fond se déclarent avec `#[AsCronTask]` sur un service du plugin.
Le modèle est expliqué dans [Tâches Cron et Attributs](../features/cron-taches-attributs.md).

## Objectif

Remplacer le pipeline `taches_generales_cron` et les déclarations XML par des services annotés, testables et injectables.

## Prérequis

- Plugin avec `config/services.php` (autowire + autoconfigure).
- Classes sous un namespace PSR-4 du plugin.

## Étapes

### 1. Tâche sur une classe (`__invoke`)

```php
namespace SpipContrib\Plugin\MonPlugin\Cron\Task;

use SpipLeague\Component\Kernel\Attribute\AsCronTask;

#[AsCronTask(name: 'monplugin_nettoyage', periode: 3600)]
final class NettoyageTask
{
    public function __invoke(): int
    {
        // logique...
        return 0;
    }
}
```

### 2. Plusieurs tâches dans un même service

```php
#[AsCronTask(name: 'monplugin_raz', periode: 86400)]
public function remiseAZero(): int
{
    return 0;
}
```

### 3. Paramètres de l’attribut

| Paramètre | Description |
| :--- | :--- |
| `name` | Nom unique (requis) |
| `periode` | Période en secondes (requis, min 60) |
| `priorite` | Priorité d’exécution (optionnel, défaut 0) |

### 4. Codes de retour

- **Legacy :** `>= 0` = succès.
- **SPIP 5.0 :** `0` = succès, `> 0` = erreur.

## Vérification

- Activer le plugin et lancer le génie (cron SPIP).
- Vérifier que la tâche apparaît et s’exécute sans erreur dans les logs.

## Voir aussi

- [Tâches Cron et Attributs](../features/cron-taches-attributs.md) — modèle et contexte
- [Migrer les services d’un plugin](services-plugin.md)
