# Guard (écran de sécurité moderne)

SPIP 5 remplace l’**écran de sécurité** historique (`spip/security`, fichier `ecran_securite.php` dans le répertoire de configuration du site) par le composant **`spip-league/guard`** : un moteur de **règles de protection précoce des  Request** exécuté très tôt dans le cycle HTTP.

Ce n’est **pas** le composant d’authentification Symfony (login, rôles, firewall). Guard traite le trafic automatisé et la charge : bots, abus d’URL, delestage sous charge serveur.

## Fonctionnement

1. Au premier hit, le conteneur Symfony charge les services du package `spip-league/guard` (liste figée côté kernel).
2. Le listener **`RequestGuardListener`** s’enregistre sur `kernel.request` (priorité **2048**), avant le bootstrap legacy.
3. Il exécute une **`GuardRuleChain`** : les règles déclarées, par priorités ; le **premier verdict bloquant** gagne.
4. En cas de blocage : `EarlyResponseException` avec une `Response` 403 ou 429 est émis.

Des attributs de Request sont posés : `_spip_is_bot`, `_spip_is_bot_friend`.
Les constantes legacy `_IS_BOT` et `_IS_BOT_FRIEND` sont définies.

## Règles built-in (v1)

| Règle | Rôle |
|-------|------|
| `BotClassificationRule` | Détection bot / bot « ami » via `User-Agent` (`BotPatterns`) |
| `BotAbuseUrlRule` | 403 sur double pagination / combinaisons calendrier pour les bots |
| `LoadSheddingRule` | 429 probabiliste pour les bots non amis si le load dépasse `spip.guard.load_threshold` |

Le paramètre conteneur `spip.guard.load_threshold` correspond à l’ancien `ECRAN_SECURITE_LOAD` (0 = désactivé).

## Boot legacy

Le fichier `ecrire/inc_version.php` **n’inclut plus** `config/ecran_securite.php` ni `bootstrap/mitigation.php`. La mitigation par défaut passe uniquement par le listener HTTP.

Un site peut encore installer un **prepend** `auto_prepend_file` côté hébergeur (hors périmètre v1 du package) ; le package ne fournit pas de générateur de prepend pour le moment.

## Étendre avec un plugin

1. Créer une classe implémentant `GuardRuleInterface` (`evaluate(GuardContext): GuardVerdict`).
2. Marquer la classe avec **`#[AsGuard(priority: …)]`** (priorité sur le tag `spip.guard` ; plus élevé = évalué en premier).
3. Déclarer le service dans `config/services.php` du plugin (autoconfigure activé à la compilation).

Exemple minimal :

```php-inline
use SpipLeague\Component\Guard\Attribute\AsGuard;
use SpipLeague\Component\Guard\GuardContext;
use SpipLeague\Component\Guard\GuardRuleInterface;
use SpipLeague\Component\Guard\GuardVerdict;

#[AsGuard(priority: 50)]
final class ApiRateGuard implements GuardRuleInterface
{
    public function evaluate(GuardContext $context): GuardVerdict
    {
        // … quota, IP, route, etc.
        return GuardVerdict::allow();
    }
}
```

## Lire la Request, pas les superglobales

Les règles doivent utiliser **`GuardContext`** (au-dessus de `Request`), pas `$_GET` / `$_POST` directement. 

## Voir aussi

- [Cycle applicatif HTTP](../architecture/cycle-applicatif-http.md)
- [HTTP Request / Response](http-request-response.md)
- [Services Symfony](services-symfony.md)
