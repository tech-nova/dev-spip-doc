# Configuration (spip-league/config)

SPIP 5.0 centralise la gestion de la configuration (métas et tables auxiliaires) dans le paquet **`spip-league/config`**, exposé via le conteneur de services.

## Architecture en trois couches

| Couche | Interface | Rôle |
|--------|-----------|------|
| Store | `ConfigStoreInterface` | Persistance brute (chaînes SQL, mémoire…) |
| Entrées | `ConfigEntries` | Working set, cache PSR-16, écritures SQL ; fabriqué par `ConfigManager` |
| Chemins | `ConfigPathAccessor` | `get`/`set` structurés (casiers, sérialisation) |
| Repository | `ConfigRepositoryInterface` | Façade publique + cycle de vie (`bootstrap`, `refresh`, `reset`) |
| Entrées (API) | `ConfigEntriesInterface` | Accès brut via `entries()` (`@internal`, pont `ecrire/`) |
| Legacy | `LegacyGlobalsBridge` | Working set synchronisé vers `$GLOBALS['meta']` (BC) |
| Manager | `ConfigManagerInterface` | Factory : assemble store + entries + repository |

Le store par défaut s’appelle **`meta`** (table `spip_meta`).

### Working set, cache et SQL

Par requête, les données suivent cet ordre :

1. **Working set** — snapshot en mémoire (via `LegacyGlobalsBridge`, miroir de `$GLOBALS['meta']` pour le code legacy).
2. **Cache PSR-16** — fichier sous `tmp/cache/config/` si le working set est vide (`bootstrap()`).
3. **Store SQL** — relecture complète (`refresh()` / `refreshFromStore()`).

`ConfigEntries::all()` renvoie le snapshot courant et peut déclencher un `bootstrap()` si le working set est vide. Ce n’est pas un simple getter passif.

Évolution prévue : introduire `ConfigWorkingSetInterface` pour découpler le working set de `$GLOBALS` ; le bridge legacy n’en serait plus qu’un adaptateur.

## Services du conteneur

| ID | Description |
|----|-------------|
| `spip.config` | Repository du store `meta` (usage courant) |
| `spip.config.manager` | Accès à tous les stores enregistrés |
| `spip.config.store_registry` | Registre des stores |
| `spip.serializer` | Sérialisation des valeurs structurées (logger canal `serializer`) |
| `spip.cache.config` | Cache fichiers `FlatFilesystem` opcache-friendly (`tmp/cache/config/`, TTL défaut 1 mois) |

Le TTL du cache est géré par l’adaptateur `spip-league/cache` (défaut `P1M`). Chaque écriture régénère le fichier cache ; l’expiration passive intervient si aucune écriture n’a lieu pendant la durée du TTL.

Préchauffage : `bin/spip cache:warmup` appelle `service('spip.config')->bootstrap()` après la recompilation des plugins.

## Utilisation en PHP moderne

```php
use function SpipLeague\Component\Kernel\service;

// Lecture / écriture (clé simple ou casier/sous-casier)
$config = service('spip.config');
$site = $config->get('nom_site', 'Mon site');
$config->set('charset', 'utf-8');
$config->set('mon_plugin/reglage', ['actif' => true]);

// Autre store (table spip_*)
$perso = service('spip.config.manager')->repository('meta_perso');
$perso->refresh();
```

## Ajouter un store custom (plugin)

Déclarer un service taggé dans le `config/services.php` du plugin :

```php
use SpipLeague\Component\Config\Store\SqlConfigStore;
use function Symfony\Component\DependencyInjection\Loader\Configurator\service;

$services
    ->set('mon_plugin.config.store', SqlConfigStore::class)
    ->arg('$tableSuffix', 'mon_table')
    ->tag('spip.config.store', ['name' => 'mon_table']);
```

Puis : `service('spip.config.manager')->repository('mon_table')`.

Dès qu’un repository non-`meta` est résolu, le `ConfigManager` enregistre automatiquement son nom dans la méta **`tables_config`**. Plus besoin de gérer manuellement cette liste depuis `lire_metas()` ou un installeur.

Pour un usage fréquent, exposer un alias dédié dans le même fichier (comme `spip.config` pour `meta`).

## Schéma SQL — `SqlConfigStore::install()` / `::uninstall()`

`SqlConfigStore` porte la création et la suppression de la table SQL (`spip_<store>`) via les helpers legacy `trouver_table` / `creer_ou_upgrader_table` / `sql_drop_table`. Cette responsabilité sera reprise par le futur composant DBAL ; en attendant, le wrapper `installer_table_meta()` / `supprimer_table_meta()` ne fait que déléguer.

```php
$store = new SqlConfigStore('mon_table');
$store->install();   // crée spip_mon_table si nécessaire
$store->uninstall(); // supprime si la table est vide (sauf 'meta')
```

## Pont legacy

Les fonctions globales **`lire_config()`**, **`ecrire_config()`**, **`effacer_config()`**, **`ecrire_meta()`**, **`lire_metas()`**, **`effacer_meta()`**, **`installer_table_meta()`** et **`supprimer_table_meta()`** restent disponibles et délèguent aux repositories (`entries()` pour l’accès brut type `ecrire_meta`).

> Doctrine : le pont ne lit ni n’écrit `$GLOBALS[$table]` directement, et utilise `request_stack` plutôt que `$_GET`. La synchronisation vers `$GLOBALS['meta']` passe par `LegacyGlobalsBridge` (`@internal`), injecté par `ConfigManager` — réservée au code legacy qui lit encore `$GLOBALS['meta']['cle']`.

Le miroir **`$GLOBALS['meta']`** (et les `$GLOBALS[$store]` des tables auxiliaires) expose les **chaînes brutes** telles qu’en `spip_meta.valeur` : pas la vue désérialisée de `spip.config`. Une meta entière écrite via `->set()` / `ecrire_config()` y apparaît par exemple en `"[150]"`, alors que `lire_config('taille_preview')` renvoie l’entier `150`. Voir la section [Sérialisation des valeurs et `$GLOBALS['meta']`](../upgrade/config.md#sérialisation-des-valeurs-et-globalmeta) du guide de migration.

Voir [Migration configuration](../upgrade/config.md).
