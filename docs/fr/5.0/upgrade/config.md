# Migration — Configuration et métas

## Suppressions (SPIP 5.0)

Sans période de dépréciation, supprimées du tronc :

| Élément                       | Remplacement                                                                                     |
| ----------------------------- | ------------------------------------------------------------------------------------------------ |
| Préfixe **`methode::cle`**    | dispatch vers `lire_config_<methode>_dist` n’est plus reconnu                                    |
| `lire_config_metapack_dist`   | `service('spip.config.manager')->repository('<store>')->get(...)`                               |
| `ecrire_config_metapack_dist` | idem `->set(...)`                                                                                |
| **`expliquer_config()`**      | `SpipLeague\Component\Config\ConfigPath::parseLegacyStoreReference()` (interne au pont)          |
| **`touch_meta()`**            | `service('spip.config')->refresh()` ou régénération implicite du cache après écriture          |
| **`cache_meta()`**            | géré automatiquement par `ConfigRepository` (PSR-16 `spip.cache.config`)                         |
| **`_META_CACHE_TIME`**        | TTL par défaut de `spip.cache.config` (`FlatFilesystem`, 1 mois)                                 |
| **`_FILE_META`**              | cache PSR-16 sous `tmp/cache/config/` ; appeler `service('spip.config')->reset()` pour le purger |

## Dépréciations (5.0)

### Préfixe `/<store>/...` dans les fonctions globales

`lire_config('/meta/cle')`, `ecrire_config('/toto/casier', $v)` et `effacer_config('/store/cle')` émettent un **`trigger_deprecation`** en 5.0.

**Migration :**

```php
lire_config('/meta_perso/mon_casier');

service('spip.config.manager')->repository('meta_perso')->get('mon_casier');
service('spip.config')->get('mon_casier');
```

### `lire_config(,, false)`

Le 3ᵉ argument `$unserialize = false` est déprécié ; la (dé)sérialisation est gérée par `spip.serializer`.

## Doctrine pour le pont legacy

À partir de 5.0, le pont (`ecrire/inc/meta.php`, `ecrire/inc/config.php`) **ne lit ni n’écrit `$GLOBALS[$table]` directement**. Le miroir global reste exposé pour la BC mais comme effet de bord du `ConfigRepository`, jamais comme source de vérité. Les plugins en cours de migration doivent en faire autant.

Pour la même raison, `$_GET['renouvelle_alea']` est remplacé par le service `request_stack` :

```php
$request = service('request_stack')->getCurrentRequest();
if ($request !== null && $request->query->has('renouvelle_alea')) {
    // ...
}
```

## Cache fichier `_FILE_META`

Le fichier `tmp/meta_cache.php` (`_FILE_META`) n’est plus utilisé. Le cache est stocké sous **`tmp/cache/config/`** via `spip-league/cache` (fichiers PHP `return …` compatibles opcache).

Lors d’une réinitialisation complète, appeler `service('spip.config')->reset()` (purge le PSR-16 **et** le miroir global) plutôt que `spip_unlink(_FILE_META)`.

## Schéma SQL des tables de configuration

`installer_table_meta()` / `supprimer_table_meta()` restent disponibles, mais la création et la suppression de la table SQL sont déléguées à **`SqlConfigStore::install()` / `::uninstall()`**. Le wrapper `installer_table_meta()` se contente d’instancier le store, d’appeler `install()` puis de rafraîchir le repository associé. Idem pour la suppression. L’enregistrement du store dans la meta **`tables_config`** est désormais réalisé automatiquement par `ConfigManager` dès qu’un repository non-`meta` est créé.

## Signatures stables

Les signatures des fonctions globales **`lire_config`**, **`ecrire_config`**, **`effacer_config`**, **`ecrire_meta`**, **`lire_metas`**, **`effacer_meta`**, **`installer_table_meta`**, **`supprimer_table_meta`** sont inchangées pour les plugins existants.

## Plugins tiers

- Vérifier l’absence d’appels **`methode::`** (traités désormais comme des clés littérales).
- Remplacer les appels `touch_meta($antidate, $table)` par `service('spip.config.manager')->repository($table)->refresh()` si un rechargement explicite est nécessaire.
- Remplacer les `spip_unlink(_FILE_META)` par `service('spip.config')->reset()`.
- Remplacer progressivement les appels `lire_config()` par l’injection de **`ConfigRepositoryInterface`** (`spip.config`) ou **`ConfigManagerInterface`**.
