# Système de log (PSR-3)

Cette page **explique** la journalisation PSR-3 de SPIP 5.0. Pour migrer `spip_log()` ou configurer un logger de plugin, voir le guide pratique.

## En bref

SPIP 5.0 adopte **PSR-3** : `spip_logger()`, injection de `LoggerInterface`, paramètres conteneur `spip.logger.*`.

## Contexte

`spip_log()` et les constantes `_LOG_*` mélangeaient niveaux et canaux. Le nouveau stack permet rotation, filtres et loggers dédiés par plugin via `spip.logger_registry`.

## Fonctionnement

- Logger principal : service `logger` / `Psr\Log\LoggerInterface`.
- Canaux nommés : `spip_logger('mon_plugin')`.
- Configuration : `spip.logger.max_level`, `max_files`, `log_path`, etc. (souvent dans `config/custom.php`).

## Différences avec SPIP 4.x

| SPIP 4.x | SPIP 5.0 |
|----------|----------|
| `spip_log()` | `spip_logger()->info()` |
| `_LOG_ERREUR`, etc. | `error()`, `warning()`, … |
| Globales `$nombre_de_logs` | Paramètres `spip.logger.*` |

## Voir aussi

- [Migrer et configurer les logs](../upgrade/logger.md)
- [Services d’un plugin](services-symfony.md)
