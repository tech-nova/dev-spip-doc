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

## Sérialisation des valeurs et `$GLOBALS['meta']`

### Règle de stockage (SPIP 5)

Toute valeur de configuration est persistée en **chaîne** :

| Couche | Contenu |
|--------|---------|
| Table SQL **`spip_meta`** (colonne `valeur`) | Chaîne exacte écrite en base |
| Tables auxiliaires **`spip_<store>`** | Même règle pour les stores non-`meta` |
| Cache PSR-16 `tmp/cache/config/` | Snapshot de ces chaînes |
| Miroir **`$GLOBALS['meta']`** (et `$GLOBALS[$store]`) | **Même chaîne brute** que en SQL — pas de désérialisation automatique |

Lors d’une écriture via `ecrire_config()` (deprécié), `Spip::configs()->set()` ou `Spip::service('spip.config')->set()`, le paquet `spip-league/config` applique `ConfigPathAccessor::packValue()` :

- **Valeur déjà `string`** → stockée telle quelle (`oui`, `utf-8`, chemins, etc.).
- **Tout autre type** (`int`, `bool`, `array`, …) → sérialisation JSON via le service **`spip.serializer`** (`spip-league/serializer`), au format `[…]` (ex. entier `150` → chaîne `"[150]"`, booléen `true` → `"[true]"`, tableau → `"[{...}]"`).

La colonne `spip_meta.valeur` et le miroir global sont mis à jour **avec la même chaîne** à chaque écriture.

À ce stade, il n’y a **pas** de migration SQL automatique des anciennes valeurs : une clé n’adopte le format JSON qu’à la **prochaine écriture** via le nouveau stack (`config->set`, `ecrire_config`, etc.).

### Différence `ecrire_meta()` vs `config->set()`

`ecrire_meta()` (déprécié) (`ecrire/inc/meta.php`) délègue à `entries()->set()` en castant **toujours** la valeur en string :

```php
->set($nom, (string) $valeur, ...);
// int 150 → "150" en spip_meta et dans $GLOBALS['meta']['taille_preview']
```

`ecrire_config()` / `Spip::configs()->set()` passent par `packValue()` : un entier n’est plus casté, il est **sérialisé** :

```php
$config->set('taille_preview', 150);
// → "[150]" en spip_meta et dans $GLOBALS['meta']['taille_preview']
```

Le tronc SPIP 5 utilise désormais `config->set()` dans `actualise_metas()`, `appliquer_modifs_config()`, etc.
Les défauts numériques de `liste_metas()` (ex. `taille_preview => 150`) sont donc concernés dès qu’ils sont (ré)écrits.

### Accès direct à `$GLOBALS['meta']['nom']`

Le miroir exposé par `LegacyGlobalsBridge` est volontairement **brut** : il reflète la chaîne SQL, pas la valeur désérialisée que renvoie l’API config.

**Exemple de régression** après réécriture d’une meta entière via le nouveau chemin :

```php
// Faux si la valeur en base est "[150]"
$GLOBALS['meta']['taille_preview'] == '150';

// Strict : toujours faux dans ce cas
$GLOBALS['meta']['taille_preview'] === '150';
```

**Lecture recommandée** (désérialisation gérée par `ConfigPathAccessor` / `spip.serializer`, y compris l’ancien `serialize()` PHP avec `accept_legacy` quand applicable) :

```php
lire_config('taille_preview'); // deprécié
Spip::config('taille_preview');
// ou injection de ConfigRepositoryInterface dans un constructeur d’objet
```

### Ancien format `serialize()` PHP

Historiquement, de nombreuses métas stockent des structures via **`serialize()`** PHP (`a:…` en base), par exemple `ecrire_meta('plugin_installes', serialize($liste))` ou des casiers `ecrire_config`.

| Situation | En base / `$GLOBALS` | Lecture |
|-----------|----------------------|---------|
| Clé **non réécrite** depuis SPIP 5 | Blob `serialize()` inchangé | `lire_config()` / `->get()` gèrent le legacy |
| Clé **réécrite** via `config->set()` / `ecrire_config()` | Format JSON `[…]` | `lire_config()` / `->get()` ; ne pas faire `unserialize($GLOBALS['meta'][…])` sur le miroir |

Sur une clé migrée vers JSON, `unserialize($GLOBALS['meta']['cle'])` sur le miroir global **échoue** ou est incohérent : le miroir contient la chaîne JSON brute, pas un blob PHP `serialize()`.

### Tableau récapitulatif

| Écriture | Type en PHP | `spip_meta.valeur` / `$GLOBALS['meta']['cle']` | `lire_config('cle')` |
|----------|-------------|-----------------------------------------------|----------------------|
| `ecrire_meta('x', 150)` | int | `"150"` (cast) | `150` (int) si désérialisé comme nombre, ou chaîne selon heuristique |
| `config->set('x', 150)` | int | `"[150]"` | `150` (int) |
| `ecrire_meta('x', 'oui')` | string | `"oui"` | `"oui"` |
| `config->set('x', 'oui')` | string | `"oui"` | `"oui"` |
| `ecrire_meta('x', serialize($t))` | string (blob) | `a:…` | tableau / structure |
| `config->set('x', $t)` (array) | array | `"[…]"` (JSON) | array |

### Checklist plugins

- Remplacer toutes les lectures **`$GLOBALS['meta']['cle']`** par `Spip::config('cle')`
- Remplacer toutes les écritures **`$GLOBALS['meta']['cle'] = 'X'`** par `Spip::configs()->set('cle', 'X')`
- **Prioritairement** les lectures sensibles de **`$GLOBALS['meta']['cle']`** (comparaisons numériques, booléens, sérialisations PHP),
- **Aucune écriture** directe de **`$GLOBALS['meta']['cle'] = 'X';`** ne doit être faite : il n’y a plus aucune persistance en cache ou SQL ainsi
- Ne pas supposer qu’une `$GLOBALS['meta']['cle']` qui paraissait de type `int` reste une chaîne décimale (`"150"`) : elle deviendra `"[150]"` dans la table SQL et le mirroir `$GLOBALS['meta']['cle']`.
- Auditer les **`unserialize($GLOBALS['meta'][…])`** ; migrer vers `Spip::config()` qui s’occupera de la désérialisation.
- Si besoin de conserver pour une raison legacy une entrée "non sérialisée" en base, `Spip::configs()->set('cle', (string) 150)` conviendra, mais c’est déconseillé, le typage (int) d’origine sera perdu, la prochaine lecture retournera string '150' donc.
- Même vigilance pour les tables meta auxiliaires (`$GLOBALS['spip_table_meta']`) : mêmes règles de persistance et de miroir.

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
- Tenir compte du [changement de sérialisation](#sérialisation-des-valeurs-et-globalmeta) pour tout accès direct à `$GLOBALS['meta']` ou `unserialize()` sur des métas.
