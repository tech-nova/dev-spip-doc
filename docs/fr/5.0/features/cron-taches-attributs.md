# Tâches Cron et Attributs

En SPIP 5.0, les tâches de fond se déclarent avec l'attribut **`#[AsCronTask]`** sur une classe ou une méthode
de service, remplaçant le pipeline `taches_generales_cron` et les déclarations `paquet.xml`.
Les tâches deviennent des services injectables et testables.

Déclaration dans un plugin : [Déclarer des tâches cron](../guides/cron-taches-attributs.md).

## Usage typique

```php
use SpipLeague\Component\Kernel\Attribute\AsCronTask;

#[AsCronTask(name: 'monplugin_nettoyage', periode: 3600)]
final class NettoyageTask
{
    public function __invoke(): int
    {
        // logique de la tâche…
        return 0; // 0 = succès (convention Unix)
    }
}
```

## Fonctionnement

- L’attribut porte un **nom** unique et une **période** minimale (60 s).
- La classe peut implémenter `__invoke()` ou exposer plusieurs méthodes annotées.
- Le conteneur découvre les tâches via autoconfigure, comme pour les listeners de pipelines.

## Différences avec SPIP 4.x

| SPIP 4.x | SPIP 5.0 |
|----------|----------|
| Pipeline `taches_generales_cron` | `#[AsCronTask]` |
| Déclaration dans `paquet.xml` | Code + `config/services.php` |
| Code retour `>= 0` | Code retour `0` = succès |

## Limites et pièges

- Les classes de tâches doivent être des **services** du plugin (autoload + `config/services.php`).
- Ne pas mélanger les conventions de code de retour legacy et moderne.

## Voir aussi

- [Déclarer des tâches cron](../guides/cron-taches-attributs.md)
- [Services et injection de dépendances](services-symfony.md)
