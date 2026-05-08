# Système de Log (PSR-3)

SPIP 5.0 modernise son système de journalisation en adoptant le standard **PSR-3**. Cela permet d'utiliser des outils de log standards, de faciliter les tests et de bénéficier de l'injection de dépendances.

## Utilisation de base

### La fonction `spip_logger()`
La fonction `spip_log()` est dépréciée au profit de `spip_logger()`. Cette nouvelle fonction retourne une instance compatible avec `Psr\Log\LoggerInterface`.

**Avant :**
```php-inline
spip_log('Message d’info');
spip_log('Message d’erreur', _LOG_ERREUR);
spip_log('Message spécifique', 'mon_plugin');
```

**Après :**
```php-inline
spip_logger()->info('Message d’info');
spip_logger()->error('Message d’erreur');
spip_logger('mon_plugin')->info('Message spécifique');
```

### Niveaux de gravité (PSR-3)
Les constantes `_LOG_DEBUG`, `_LOG_ERREUR`, etc., sont dépréciées au profit des méthodes de la `LoggerInterface` :
`debug()`, `info()`, `notice()`, `warning()`, `error()`, `critical()`, `alert()`, `emergency()`.

## Configuration

La configuration du logger se fait désormais via les paramètres du conteneur de services (généralement dans `config/custom.php`).

### Correspondance avec les anciennes constantes

| Paramètre | Description | Ancienne constante / globale |
| :--- | :--- | :--- |
| `spip.logger.max_level` | Niveau de gravité minimum à logger | `_LOG_FILTRE_GRAVITE` |
| `spip.logger.max_files` | Nombre de fichiers de rotation | `$nombre_de_logs` |
| `spip.logger.max_size` | Taille max d'un fichier (Mo) | `$taille_des_logs` |
| `spip.logger.max_log` | Taille max d'un message | `_MAX_LOG` |
| `spip.logger.fileline` | Inclure fichier/ligne dans le log | `_LOG_FILELINE` |
| `spip.logger.brut` | Log sans formatage SPIP | `_LOG_BRUT` |
| `spip.logger.log_path` | Chemin des fichiers de log | `_FILE_LOG` / `_FILE_LOG_SUFFIX` |

### Exemple de surcharge
```php-inline
// config/custom.php
return static function (ContainerConfigurator $container): void {
    $container->parameters()
        ->set('spip.logger.max_level', 'info')
        ->set('spip.logger.max_files', 14);
};
```

## Injection de dépendances

Dans vos classes (services, listeners, tâches cron), privilégiez l'injection du logger plutôt que l'appel à la fonction globale.

### Utiliser le logger par défaut
Le service `logger` (alias de `Psr\Log\LoggerInterface`) injecte le logger principal de SPIP.

```php-inline
use Psr\Log\LoggerInterface;

final class MonService {
    public function __construct(
        private readonly LoggerInterface $logger,
    ) {}

    public function faireQuelqueChose(): void {
        $this->logger->info('Action effectuée');
    }
}
```

### Utiliser un logger spécifique (Factory)
Si vous voulez un fichier de log dédié pour votre plugin (ex: `tmp/log/mon_plugin.log`), vous devez déclarer un service spécifique dans votre `config/services.php` en utilisant la factory `spip.logger_registry`.

```php-inline
// config/services.php
$services->set('spip.mon_plugin.logger', LoggerInterface::class)
    ->factory([service('spip.logger_registry'), 'get'])
    ->args(['mon_plugin']); // Nom du fichier de log
```

### Injecter un logger spécifique avec `#[Autowire]`
Pour injecter ce logger spécifique dans l'une de vos classes, utilisez l'attribut `#[Autowire]` de Symfony.

```php-inline
use Psr\Log\LoggerInterface;
use Symfony\Component\DependencyInjection\Attribute\Autowire;

final class MaTacheCron {
    public function __construct(
        #[Autowire(service: 'spip.mon_plugin.logger')]
        private readonly LoggerInterface $logger,
    ) {}

    public function __invoke(): int {
        $this->logger->info('Début de la tâche');
        return 0;
    }
}
```
