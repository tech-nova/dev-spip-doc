# Paramètres de configuration `spip.*`

SPIP 5.0 utilise des paramètres dans son conteneur de services pour centraliser la configuration. Ces paramètres peuvent être utilisés dans vos fichiers `services.php` via la syntaxe `%spip.nom_du_parametre%`.

## Répertoires (Dirs)

Les paramètres `spip.dirs.*` définissent les chemins relatifs des répertoires principaux de SPIP. Ils sont utilisés par le Kernel pour calculer les chemins absolus.

| Paramètre | Description | Valeur par défaut |
| :--- | :--- | :--- |
| `spip.dirs.core` | Répertoire du cœur | `ecrire/` |
| `spip.dirs.tmp` | Répertoire temporaire | `tmp/` |
| `spip.dirs.var` | Répertoire des données locales | `local/` |
| `spip.dirs.doc` | Répertoire des documents (IMG) | `IMG/` |
| `spip.dirs.extensions` | Répertoire des plugins-dist | `plugins-dist/` |
| `spip.dirs.plugins` | Répertoire des plugins utilisateur | `plugins/` |
| `spip.dirs.template` | Squelettes de la distribution | `squelettes-dist/` |
| `spip.dirs.custom` | Squelettes utilisateur | `squelettes/` |
| `spip.dirs.private_template` | Squelettes de l'espace privé | `prive/` |
| `spip.dirs.log` | Répertoire des logs | `%spip.dirs.tmp%log/` |

### Accès aux chemins via le Kernel

Dans votre code PHP, privilégiez l'utilisation des méthodes du Kernel pour obtenir des chemins fiables (absolus ou relatifs au contexte) :

```php
use function SpipLeague\Component\Kernel\app;

$rootDir = app()->getRootDir();      // Racine du projet
$coreDir = app()->getCoreDir();      // ecrire/
$tmpDir  = app()->getTmpDir();       // tmp/
$cacheDir = app()->getCacheDir();    // tmp/cache/
$logDir  = app()->getLogDir();       // tmp/log/
```

Vous pouvez aussi demander un chemin relatif au répertoire courant :
```php
$relativeTmp = app()->relative()->getTmpDir();
```

## Logger

| Paramètre | Description | Défaut |
| :--- | :--- | :--- |
| `spip.logger.max_level` | Niveau de gravité minimum à logger | `notice` |
| `spip.logger.max_files` | Nombre maximum de fichiers de rotation | `4` |
| `spip.logger.max_size` | Taille maximum d'un fichier (en Mo) | `100` |
| `spip.logger.max_log` | Taille maximum d'un message | `100k` |
| `spip.logger.fileline` | Inclure fichier/ligne dans le log | `false` |
| `spip.logger.brut` | Log sans formatage SPIP | `false` |
| `spip.logger.log_path` | Chemin des fichiers de log | `tmp/log/%s.log` |

Pour plus de détails sur la correspondance avec les anciennes constantes et l'utilisation avancée, consultez le guide : **[Système de Log (PSR-3)](../features/logger.md)**.

## Sites et Syndication

Plusieurs configurations historiques liées à la syndication ont été migrées vers des paramètres du conteneur.

| Paramètre | Description | Ancienne constante / globale |
| :--- | :--- | :--- |
| `spip.sites.rss_controler_dates` | Contrôler les dates des flux RSS | `controler_dates_rss` (globale) |
| `spip.sites.rss_dereferencer_url` | Déférencer les URLs de syndication | `_SYNDICATION_DEREFERENCER_URL` |
| `spip.sites.rss_max_items` | Nombre max d'items par flux | `_SYNDICATION_MAX_ITEMS` |
| `spip.sites.periode_syndication` | Période de rafraîchissement (secondes) | `_PERIODE_SYNDICATION` |
| `spip.sites.periode_syndication_suspendue` | Période si syndication suspendue | `_PERIODE_SYNDICATION_SUSPENDUE` |
| `spip.sites.article_descriptif_max_longueur` | Longueur max du descriptif | `_SYNDIC_ARTICLE_DESCRIPTIF_MAX_LONGUEUR` |
| `spip.sites.syndication_url_unique` | Forcer l'URL unique | `_SYNDICATION_URL_UNIQUE` |
| `spip.sites.syndication_correction` | Appliquer des corrections | `_SYNDICATION_CORRECTION` |

## Statistiques

| Paramètre | Description | Ancienne constante |
| :--- | :--- | :--- |
| `spip.stats.cron_lot_fichiers_visite` | Taille du lot de fichiers visite | `_CRON_LOT_FICHIERS_VISITE` |
| `spip.stats.ip_flood_ttl` | TTL pour la détection du flood IP | `_IP_FLOOD_TTL` |

## Tâches Cron

| Paramètre | Description | Ancienne constante |
| :--- | :--- | :--- |
| `spip.cron.svp_actualiser_depots.enabled` | Activer l'actualisation des dépôts | `_SVP_CRON_ACTUALISATION_DEPOTS` |
| `spip.cron.svp_actualiser_depots.period` | Période d'actualisation (secondes) | `_SVP_PERIODE_ACTUALISATION_DEPOTS` |

### Surcharge des tâches cron
Vous pouvez activer/désactiver ou changer la période de n'importe quelle tâche cron via les paramètres :
- `spip.cron.{nom_tache}.enabled` (booléen)
- `spip.cron.{nom_tache}.period` (secondes)

## Surcharge des paramètres
Pour surcharger ces paramètres, créez ou modifiez le fichier **`config/custom.php`** :

```php
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;

return static function (ContainerConfigurator $container): void {
    $container->parameters()
        ->set('spip.logger.max_files', 30)
        ->set('spip.sites.periode_syndication', 3600);
};
```
