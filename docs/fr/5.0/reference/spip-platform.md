# Référence `Platform`

Service conteneur : **`spip.platform`**
Interface : `SpipLeague\Component\Kernel\PlatformInterface`
Implémentation : `SpipLeague\Component\Kernel\Platform`

Accès recommandé : `Spip::platform()`.

Explication : [Plateforme d'exécution](../features/platform.md).

## Variables d'environnement

| Méthode | Signature | Description |
|---------|-----------|-------------|
| `getEnv` | `getEnv(string $name): ?string` | Lit `$_SERVER`, puis `$_ENV`, puis `getenv()` |
| `putEnv` | `putEnv(string $name, string $value): void` | Écrit dans `$_SERVER` et `$_ENV` (sans `putenv()`) |
| `clearEnv` | `clearEnv(string $name): void` | Supprime de `$_SERVER` et `$_ENV` |

Variables couramment lues :

| Variable | Usage |
|----------|-------|
| `APP_ENV` | Environnement applicatif (`prod`, `dev`, `test`) |
| `SPIP_CACHE_DIR` | Surcharge du répertoire de cache |
| `SPIP_ETC_DIR` | Surcharge du répertoire de configuration |
| `TEST_DIR` | Racine d'installation de test (`APP_ENV=test`) |

## Plateforme

| Méthode | Signature | Description |
|---------|-----------|-------------|
| `isWindows` | `isWindows(): bool` | `PHP_OS_FAMILY === 'Windows'` |
| `isCli` | `isCli(): bool` | `PHP_SAPI === 'cli'` |
| `getCwd` | `getCwd(bool $allowEmpty = false): string` | Répertoire de travail courant |
| `getDevNull` | `getDevNull(): string` | `NUL` (Windows) ou `/dev/null` |

## Correspondance anciens patterns

| Ancien pattern | Remplacement |
|----------------|--------------|
| `SpipContainerFactory::readEnv($name)` | `Spip::platform()->getEnv($name)` |
| `PHP_SAPI === 'cli'` | `Spip::platform()->isCli()` |
| `PHP_SAPI !== 'cli'` | `!Spip::platform()->isCli()` |
| `_OS_SERVEUR == 'windows'` | `Spip::platform()->isWindows()` |
| `isset($_SERVER['SERVER_SOFTWARE']) && str_contains(..., '(Win')` ou `PHP_OS_FAMILY === 'Windows'` | `Spip::platform()->isWindows()` |

## Voir aussi

- [Plateforme d'exécution](../features/platform.md)
- [Environnement et Kernel](../guides/migration/environnement-kernel.md)
- [SpipDirectories](spip-directories.md)
