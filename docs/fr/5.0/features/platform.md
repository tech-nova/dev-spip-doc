# Plateforme d'exécution (`spip.platform`)

SPIP 5.0 centralise les vérifications liées à la **plateforme d'exécution** (OS, SAPI PHP,
variables d'environnement) dans le service **`spip.platform`**
(`SpipLeague\Component\Kernel\Platform`).

Mise en œuvre : [Environnement et Kernel](../guides/migration/environnement-kernel.md).
Signatures : [Référence Platform](../reference/spip-platform.md).

## En bref

- **Variables d'environnement** : `getEnv()`, `putEnv()`, `clearEnv()` — lecture/écriture
  compatible Dotenv Symfony (sans `putenv()`, non thread-safe).
- **OS** : `isWindows()` via `PHP_OS_FAMILY` (plus fiable que l'ancienne détection
  `SERVER_SOFTWARE`).
- **SAPI** : `isCli()` remplace les tests `PHP_SAPI === 'cli'`.
- **Utilitaires** : `getCwd()`, `getDevNull()`.

Extrait canonique :

```php
$platform = Spip::platform();
$env = $platform->getEnv('APP_ENV') ?? 'prod';

if ($platform->isCli()) {
    // mode console
}

if ($platform->isWindows()) {
    // comportement spécifique Windows
}
```

## Injection de dépendance

Dans un service Symfony :

```php
use SpipLeague\Component\Kernel\Util\PlatformInterface;

final class MonService
{
    public function __construct(
        private readonly PlatformInterface $platform,
    ) {}

    public function run(): void
    {
        if ($this->platform->isCli()) {
            // ...
        }
    }
}
```

## Constante legacy `_OS_SERVEUR`

La constante `_OS_SERVEUR` (historiquement détectée via `SERVER_SOFTWARE`) est désormais
dérivée de `Spip::platform()->isWindows()`.

Préférer `Spip::platform()->isWindows()` dans le nouveau code.

## Voir aussi

- [Répertoires SPIP](directories.md)
- [Environnement et Kernel](../guides/migration/environnement-kernel.md)
- [Référence Platform](../reference/spip-platform.md)
- [Façade Spip](acces-services-spip.md)
