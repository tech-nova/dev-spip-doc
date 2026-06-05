# Paramètres SPIP (conteneur)

Page de **référence** : paramètres `spip.*` du conteneur de services SPIP 5.0.
Les valeurs par défaut du cœur sont définies dans `config/spip/*.php` et peuvent être
surchargées par site (`config/custom.php`) ou par un plugin (`config/services.php`).

## Inspecter les valeurs effectives

La commande CLI affiche tous les paramètres résolus du conteneur (défauts, surcharges et valeurs dérivées) :

```bash
bin/spip spip:config:dump
```

Les chemins y apparaissent résolus en absolu et les paramètres dérivés (ci-dessous) sont calculés.
C'est la source de vérité pour connaître la valeur réellement appliquée sur une instance.

## Répertoires (`spip.dirs.*`)

| Paramètre | Défaut | Description |
|-----------|--------|-------------|
| `spip.dirs.doc` | `IMG/` | Fond documentaire permanent et accessible (logos, documents…) |
| `spip.dirs.tmp` | `tmp/` | Fichiers temporaires inaccessibles (cache, sessions, logs) |
| `spip.dirs.var` | `local/` | Fichiers temporaires accessibles (assets compilés, images générées) |
| `spip.dirs.core` | `ecrire/` | Noyau historique de SPIP |
| `spip.dirs.extensions` | `plugins-dist/` | Plugins fournis avec la distribution (activés d'office) |
| `spip.dirs.plugins` | `plugins/` | Plugins installables de l'instance |
| `spip.dirs.extra_plugins` | *(vide)* | Plugins installables pour un site mutualisé |
| `spip.dirs.template` | `squelettes-dist/` | Jeu de squelettes par défaut de la distribution |
| `spip.dirs.custom` | `squelettes/` | Personnalisation des squelettes du site |
| `spip.dirs.extra_custom` | *(vide)* | Chemins de squelettes additionnels (inutilisé actuellement) |
| `spip.dirs.private_template` | `prive/` | Squelettes de l'espace privé |
| `spip.dirs.log` | `%spip.dirs.tmp%log/` | Répertoire des logs |
| `spip.dirs.sessions` | `%spip.dirs.tmp%sessions/` | Répertoire des sessions |

## Journalisation (`spip.logger.*`)

| Paramètre | Défaut | Description |
|-----------|--------|-------------|
| `spip.logger.max_files` | `4` | Nombre de fichiers de rotation conservés (≈ `$nombre_de_logs`) |
| `spip.logger.max_size` | `100` | Taille maximale d'un fichier de log, en **Kio** (voir `max_size_bytes`) |
| `spip.logger.max_log` | `100` | Nombre maximal d'entrées conservées par fichier |
| `spip.logger.max_level` | `notice` | Niveau PSR-3 minimal journalisé (≈ `_LOG_FILTRE_GRAVITE`) |
| `spip.logger.fileline` | `false` | Ajoute l'origine `fichier:ligne` à chaque entrée |
| `spip.logger.brut` | `false` | Écrit les messages bruts, sans mise en forme |
| `spip.logger.log_path` | `%spip.dirs.log%%s.log` | Motif de chemin des fichiers (`%s` = canal ; ≈ `_FILE_LOG`) |

## Routage (`spip.routes.*`)

| Paramètre | Défaut | Description |
|-----------|--------|-------------|
| `spip.routes.front_office` | `/` | Préfixe d'URL de l'espace public |
| `spip.routes.back_office` | `ecrire/` | Préfixe d'URL de l'espace privé |

## Front-office (`spip.frontend.*`)

| Paramètre | Défaut | Description |
|-----------|--------|-------------|
| `spip.frontend.js_subdir` | `javascript/` | Sous-dossier des scripts JS publics |
| `spip.frontend.private_js_subdir` | `prive/javascript/` | Sous-dossier des scripts JS de l'espace privé |

## Documentation (`spip.docs.*`)

| Paramètre | Défaut | Description |
|-----------|--------|-------------|
| `spip.docs.home_server` | `https://www.spip.net` | Serveur de l'aide / documentation en ligne |
| `spip.docs.url_glossaire` | `https://@lang@.wikipedia.org/wiki/%s` | Modèle d'URL du glossaire (`@lang@`, `%s`) |

## Sécurité (`spip.guard.*`)

Défini par le composant `spip-league/guard`.

| Paramètre | Défaut | Description |
|-----------|--------|-------------|
| `spip.guard.load_threshold` | `0` | Seuil de charge (load average) déclenchant le délestage (429) ; `0` = désactivé. Remplace `ECRAN_SECURITE_LOAD` |

## Mises à jour (`spip.update.*`)

Défini par `ecrire/config/services.php` (vérification des versions de SPIP).

| Paramètre | Défaut | Description |
|-----------|--------|-------------|
| `spip.update.versions_server_url` | `https://www.spip.net/spip_loader.api` | URL de l'API listant les versions de SPIP |
| `spip.update.versions_cache_file` | `spip_versions_list.json` | Nom du fichier de cache de la liste des versions |

## Paramètres dérivés (lecture seule)

Calculés par le conteneur (chemins résolus en absolu, valeurs déduites) ; ne pas les définir manuellement.

| Paramètre | Source | Description |
|-----------|--------|-------------|
| `spip.dirs.project` | installation | Racine absolue du projet (ex. `/var/www/html/`) |
| `spip.dirs.etc` | `spip.dirs.project` | Répertoire de configuration absolu (`config/`) |
| `spip.dirs.cache` | `spip.dirs.tmp` | Répertoire de cache absolu (`tmp/cache/`) |
| `spip.logger.max_size_bytes` | `spip.logger.max_size` × 1024 | Taille maximale d'un fichier de log, en octets |
| `kernel.environment` | installation + `.env` | Environnement applicatif résolu (`dev`, `prod`…) |

## Modifier ou créer des paramètres

Les défauts du cœur (`config/spip/*.php`) ne doivent **pas** être édités directement (écrasés à chaque mise à jour). Trois points d'extension :

**Surcharge d'un site** — `config/custom.php` à la racine, chargé **après** les défauts :

```php
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;

return static function (ContainerConfigurator $container): void {
    $container->parameters()
        ->set('spip.logger.max_level', 'debug');
};
```

**Paramètres d'un plugin** — dans son `config/services.php`, via `parameters()->set('mon_plugin.xxx', …)`.
Préférer un préfixe propre au plugin plutôt que surcharger les `spip.*` du cœur.

**Interpolation** — un paramètre peut en référencer un autre avec `%nom%` (ex. `spip.dirs.log` vaut `%spip.dirs.tmp%log/`).

**Lecture** — `Spip::param('spip.dirs.tmp')` en procédural, ou injection `%spip.dirs.tmp%` dans une définition de service.

Des composants et plugins déclarent aussi leurs propres paramètres (ex. `spip.guard.*`, `spip.update.*`,
ou des bascules de tâches cron comme `spip.cron.svp_actualiser_depots.enabled`). La commande
`bin/spip spip:config:dump` liste l'ensemble réellement chargé.

## Voir aussi

- [Configuration (feature)](../features/config.md)
- [Migration — Configuration et métas](../guides/migration/config.md)
