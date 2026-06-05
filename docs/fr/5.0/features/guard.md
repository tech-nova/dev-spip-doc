# Guard (écran de sécurité moderne)

**`spip-league/guard`** est le successeur de l'écran de sécurité historique : il exécute des **règles de protection**
sur `kernel.request` (bots, abus d'URL, délestage) avant le legacy.
Ce n'est **pas** l'authentification Symfony (login, firewall).

Ajouter une règle dans un plugin : [Étendre Guard](../guides/guard-extension.md).

## Usage typique

Une règle implémente `GuardRuleInterface` et est découverte via l'attribut `#[AsGuard]` :

```php
use SpipLeague\Component\Guard\Attribute\AsGuard;
use SpipLeague\Component\Guard\GuardContext;
use SpipLeague\Component\Guard\GuardRuleInterface;
use SpipLeague\Component\Guard\GuardVerdict;

#[AsGuard(priority: 50)]
final class ApiRateGuard implements GuardRuleInterface
{
    public function evaluate(GuardContext $context): GuardVerdict
    {
        return GuardVerdict::allow();
    }
}
```

## Fonctionnement

1. Chargement des services `spip-league/guard` au boot.
2. `GuardRuleChain` : première règle bloquante gagne (403 / 429 via `EarlyResponseException`).
3. Attributs Request `_spip_is_bot`, `_spip_is_bot_friend` ; constantes legacy `_IS_BOT`, `_IS_BOT_FRIEND`.

## Règles intégrées (v1)

| Règle | Rôle |
|-------|------|
| `BotClassificationRule` | Bot / bot « ami » via `User-Agent` |
| `BotAbuseUrlRule` | 403 sur abus d’URL (pagination, calendrier) |
| `LoadSheddingRule` | 429 si charge > `spip.guard.load_threshold` |

## Différences avec SPIP 4.x

- Plus d’inclusion automatique de `config/ecran_securite.php` dans `inc_version.php`.
- Paramètre `spip.guard.load_threshold` remplace `ECRAN_SECURITE_LOAD`.

## Limites et pièges

- Les règles doivent lire **`GuardContext`** / `Request`, pas `$_GET` / `$_POST`.
- L’extension par plugin est documentée dans le guide pratique.

## Voir aussi

- [Étendre Guard dans un plugin](../guides/guard-extension.md)
- [Cycle applicatif HTTP](../architecture/cycle-applicatif-http.md)
- [HTTP Request / Response](http-request-response.md)
