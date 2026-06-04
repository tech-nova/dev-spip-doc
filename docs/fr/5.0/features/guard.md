# Guard (écran de sécurité moderne)

Cette page **explique** **`spip-league/guard`**, successeur de l’écran de sécurité historique.
Pour ajouter une règle dans un plugin, voir le guide pratique.

## En bref

Guard exécute des **règles de protection** sur `kernel.request` (bots, abus d’URL, delestage).
Ce n’est **pas** l’authentification Symfony (login, firewall).

## Contexte

L’ancien `ecran_securite.php` était inclus depuis le bootstrap legacy.
SPIP 5.0 centralise la mitigation dans `RequestGuardListener` (priorité 2048) avant le legacy.

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

- [Étendre Guard dans un plugin](../upgrade/guard-extension.md)
- [Cycle applicatif HTTP](../architecture/cycle-applicatif-http.md)
- [HTTP Request / Response](http-request-response.md)
