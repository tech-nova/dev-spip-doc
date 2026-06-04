# Migration — Configuration et métas

Ce guide pratique décrit **comment** migrer configuration et métas vers `spip-league/config`.
Voir [Configuration (feature)](../features/config.md) pour le modèle.

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

À partir de 5.0, le pont (`ecrire/inc/meta.php`, `ecrire/inc/config.php`) **ne lit ni n’écrit `$GLOBALS[$table]` directement**.
Le miroir global reste exposé pour la BC comme effet de bord du `ConfigRepository`, jamais comme source de vérité.
Les plugins en cours de migration doivent en faire autant.

Pour la même raison, `$_GET['renouvelle_alea']` est remplacé par le service `request_stack` :

```php
$request = service('request_stack')->getCurrentRequest();
if ($request !== null && $request->query->has('renouvelle_alea')) {
    // ...
}
```

## Sérialisation des valeurs et miroir meta

### Règle de stockage (SPIP 5)

Toute valeur de configuration est persistée en **chaîne** :

| Couche | Contenu |
|--------|---------|
| Table SQL **`spip_meta`** (colonne `valeur`) | Chaîne exacte écrite en base |
| Tables auxiliaires **`spip_<store>`** | Même règle pour les stores non-`meta` |
| Cache PSR-16 `tmp/cache/config/` | Snapshot de ces chaînes |
| Miroir **`$GLOBALS['meta']`** (et `$GLOBALS[$store]`) | **Même chaîne brute** que en SQL — pas de désérialisation auto |

Lors d’une écriture via `ecrire_config()` (deprécié), `Spip::configs()->set()` ou `Spip::service('spip.config')->set()`,
le paquet `spip-league/config` applique `ConfigPathAccessor::packValue()` :

- **Valeur déjà `string`** → stockée telle quelle (`oui`, `utf-8`, chemins, etc.).
- **Tout autre type** (`int`, `bool`, `array`, …) → JSON via **`spip.serializer`** (`spip-league/serializer`), format `[…]`
  (ex. `150` → `"[150]"`, `true` → `"[true]"`).

La colonne `spip_meta.valeur` et le miroir global sont mis à jour **avec la même chaîne** à chaque écriture.

À ce stade, pas de migration SQL automatique des anciennes valeurs :
une clé n’adopte le JSON qu’à la **prochaine écriture** (`config->set`, `ecrire_config`, etc.).

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

**Lecture recommandée** (désérialisation via `ConfigPathAccessor` / `spip.serializer`, legacy `serialize()` si applicable) :

```php
lire_config('taille_preview'); // deprécié
Spip::config('taille_preview');
// ou injection de ConfigRepositoryInterface dans un constructeur d’objet
```

### Ancien format `serialize()` PHP

Historiquement, de nombreuses métas utilisent **`serialize()`** PHP (`a:…` en base),
ex. `ecrire_meta('plugin_installes', serialize($liste))`.

| Situation | En base / `$GLOBALS` | Lecture |
|-----------|----------------------|---------|
| Clé **non réécrite** depuis SPIP 5 | Blob `serialize()` inchangé | `lire_config()` / `->get()` gèrent le legacy |
| Clé **réécrite** via `config->set()` / `ecrire_config()` | Format JSON `[…]` | `lire_config()` / `->get()` ; pas `unserialize()` sur le miroir |

Sur une clé migrée vers JSON, `unserialize($GLOBALS['meta']['cle'])` **échoue** :
le miroir contient la chaîne JSON brute, pas un blob `serialize()`.

### Tableau récapitulatif

| Écriture | Type en PHP | `spip_meta.valeur` / `$GLOBALS['meta']['cle']` | `lire_config('cle')` |
|----------|-------------|-----------------------------------------------|----------------------|
| `ecrire_meta('x', 150)` | int | `"150"` (cast) | `150` (int) ou chaîne selon heuristique |
| `config->set('x', 150)` | int | `"[150]"` | `150` (int) |
| `ecrire_meta('x', 'oui')` | string | `"oui"` | `"oui"` |
| `config->set('x', 'oui')` | string | `"oui"` | `"oui"` |
| `ecrire_meta('x', serialize($t))` | string (blob) | `a:…` | tableau / structure |
| `config->set('x', $t)` (array) | array | `"[…]"` (JSON) | array |

### Checklist plugins

- Remplacer toutes les lectures **`$GLOBALS['meta']['cle']`** par `Spip::config('cle')`
- Remplacer toutes les écritures **`$GLOBALS['meta']['cle'] = 'X'`** par `Spip::configs()->set('cle', 'X')`
- **Prioritairement** les lectures sensibles de **`$GLOBALS['meta']['cle']`** (comparaisons numériques, booléens, sérialisations PHP).
- **Aucune écriture** directe **`$GLOBALS['meta']['cle'] = 'X';`** : plus de persistance cache/SQL ainsi.
- Ne pas supposer qu’un `int` en miroir reste `"150"` : après `config->set`, ce sera `"[150]"` en SQL et miroir.
- Auditer les **`unserialize($GLOBALS['meta'][…])`** ; migrer vers `Spip::config()` qui s’occupera de la désérialisation.
- `Spip::configs()->set('cle', (string) 150)` force une chaîne non JSON (déconseillé : perte du typage int).
- Même vigilance pour les tables meta auxiliaires (`$GLOBALS['spip_table_meta']`) : mêmes règles de persistance et de miroir.

## Cache fichier `_FILE_META`

Le fichier `tmp/meta_cache.php` (`_FILE_META`) n’est plus utilisé.
Le cache est sous **`tmp/cache/config/`** via `spip-league/cache` (fichiers PHP `return …`, opcache).

Lors d’une réinitialisation complète, appeler `service('spip.config')->reset()` (purge PSR-16 **et** miroir)
plutôt que `spip_unlink(_FILE_META)`.

## Schéma SQL des tables de configuration

`installer_table_meta()` / `supprimer_table_meta()` délèguent à **`SqlConfigStore::install()` / `::uninstall()`**.
Le wrapper instancie le store, appelle `install()` puis rafraîchit le repository.
L’enregistrement dans **`tables_config`** est automatique via `ConfigManager` pour tout store non-`meta`.

## Signatures stables

Les signatures globales (`lire_config`, `ecrire_config`, `effacer_config`, `ecrire_meta`, etc.) restent inchangées pour les plugins existants.

## Plugins tiers

- Vérifier l’absence d’appels **`methode::`** (traités désormais comme des clés littérales).
- Remplacer `touch_meta($antidate, $table)` par `service('spip.config.manager')->repository($table)->refresh()` si besoin.
- Remplacer les `spip_unlink(_FILE_META)` par `service('spip.config')->reset()`.
- Remplacer `lire_config()` par injection de **`ConfigRepositoryInterface`** ou **`ConfigManagerInterface`**.
- Tenir compte de la section [Sérialisation des valeurs et miroir meta](#serialisation-des-valeurs-et-miroir-meta) pour `$GLOBALS['meta']` et `unserialize()`.

## Utilisation depuis un plugin (PHP moderne)

```php
use function SpipLeague\Component\Kernel\service;

$config = service('spip.config');
$site = $config->get('nom_site', 'Mon site');
$config->set('mon_plugin/reglage', ['actif' => true]);

$perso = service('spip.config.manager')->repository('meta_perso');
$perso->refresh();
```

### Store custom

```php
$services
    ->set('mon_plugin.config.store', SqlConfigStore::class)
    ->arg('$tableSuffix', 'mon_table')
    ->tag('spip.config.store', ['name' => 'mon_table']);
```

Puis : `service('spip.config.manager')->repository('mon_table')`. Le nom est enregistré automatiquement dans la méta `tables_config`.

## Voir aussi

- [Configuration (spip-league/config)](../features/config.md)
- [Paramètres SPIP](../reference/parametres-spip.md)
- [Migrer vers la façade Spip](acces-services-spip.md)
