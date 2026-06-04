# Migrer et configurer les logs

Ce guide pratique décrit **comment** passer de `spip_log()` à PSR-3 et configurer un logger de plugin.

## Objectif

Utiliser `spip_logger()` et l’injection de `LoggerInterface` avec les paramètres du conteneur.

## Prérequis

- Plugin avec `config/services.php` pour un logger dédié (optionnel).

## Étapes

### 1. Remplacer `spip_log()`

**Avant :**

```php-inline
spip_log('Message', _LOG_ERREUR);
spip_log('Plugin', 'mon_plugin');
```

**Après :**

```php-inline
spip_logger()->error('Message');
spip_logger('mon_plugin')->info('Plugin');
```

### 2. Configurer le logger global

```php-inline
// config/custom.php
return static function (ContainerConfigurator $container): void {
    $container->parameters()
        ->set('spip.logger.max_level', 'info')
        ->set('spip.logger.max_files', 14);
};
```

| Paramètre | Ancienne équivalence |
| :--- | :--- |
| `spip.logger.max_level` | `_LOG_FILTRE_GRAVITE` |
| `spip.logger.max_files` | `$nombre_de_logs` |
| `spip.logger.log_path` | `_FILE_LOG` |

### 3. Injecter le logger dans un service

```php-inline
public function __construct(
    private readonly LoggerInterface $logger,
) {}
```

### 4. Logger dédié au plugin

```php-inline
$services->set('spip.mon_plugin.logger', LoggerInterface::class)
    ->factory([service('spip.logger_registry'), 'get'])
    ->args(['mon_plugin']);
```

```php-inline
#[Autowire(service: 'spip.mon_plugin.logger')]
private readonly LoggerInterface $logger,
```

## Vérification

- Écrire un log de test ; vérifier le fichier sous `tmp/log/`.
- Confirmer le niveau filtré selon `spip.logger.max_level`.

## Voir aussi

- [Système de log](../features/logger.md)
- [API PHP — dépréciations](php-api.md)
