# Système de log (PSR-3)

SPIP 5.0 adopte **PSR-3** pour la journalisation : la fonction `Spip::logger()`, l'injection de `LoggerInterface`
dans les services, et des paramètres conteneur `spip.logger.*` (rotation, niveau, chemins).
Des loggers dédiés par plugin sont possibles via `spip.logger_registry`.

Migrer `spip_log()` ou configurer un logger : [Logs PSR-3](../guides/logger.md).

## Usage typique

```php
Spip::logger()->error('Échec de la connexion');
Spip::logger('mon_plugin')->info('Traitement terminé');
```

Dans un service, préférer l'injection de `Psr\Log\LoggerInterface` au constructeur.

## Fonctionnement

- Logger principal : service `logger` / `Psr\Log\LoggerInterface`.
- Canaux nommés : `Spip::logger('mon_plugin')`.
- Configuration : `spip.logger.max_level`, `max_files`, `log_path`, etc. (souvent dans `config/custom.php`).

## Différences avec SPIP 4.x

| SPIP 4.x | SPIP 5.0 |
|----------|----------|
| `spip_log()` | `Spip::logger()->info()` |
| `_LOG_ERREUR`, etc. | `error()`, `warning()`, … |
| Globales `$nombre_de_logs` | Paramètres `spip.logger.*` |

## Voir aussi

- [Logs PSR-3](../guides/logger.md)
- [Services d’un plugin](services-symfony.md)
