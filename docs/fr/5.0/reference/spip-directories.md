# Référence `SpipDirectories`

Service conteneur : **`spip.directories`**
Interface : `SpipLeague\Component\Kernel\Directory\SpipDirectoriesInterface`
Implémentation : `SpipLeague\Component\Kernel\Directory\SpipDirectories`

Accès recommandé : `Spip::directories()`.

Explication : [Répertoires SPIP](../features/directories.md).

## Chemins absolus — Symfony

| Méthode | Répertoire typique | Notes |
|---------|-------------------|-------|
| `getProjectDir()` | `/` (racine projet) | Remplace `getRootDir()` |
| `getCacheDir()` | `tmp/cache/` ou `var/cache/{env}/` | Override : `SPIP_CACHE_DIR` |
| `getBuildDir()` | = `getCacheDir()` par défaut | Artefacts compile-time |
| `getShareDir()` | `null` ou configuré | Données multi-serveurs (`spip.dirs.share`) |
| `getLogDir()` | `tmp/log/` ou `var/log/` | Paramètre `spip.dirs.log` |

## Chemins absolus — SPIP

| Méthode | Paramètre | Répertoire typique |
|---------|-----------|-------------------|
| `getCoreDir()` | `spip.dirs.core` | `ecrire/` |
| `getExtensionsDir()` | `spip.dirs.extensions` | `plugins-dist/` |
| `getPluginsDir()` | `spip.dirs.plugins` | `plugins/` |
| `getExtraPluginsDir()` | `spip.dirs.extra_plugins` | `null` ou chemin mutualisé |
| `getTemplateDir()` | `spip.dirs.template` | `squelettes-dist/` |
| `getPrivateTemplateDir()` | `spip.dirs.private_template` | `prive/` |
| `getCustomDir()` | `spip.dirs.custom` | `squelettes/` |
| `getConfigDir()` | — | `config/` (override : `SPIP_ETC_DIR`) |
| `getDocDir()` | `spip.dirs.doc` | `IMG/` |
| `getPublicAssetsDir()` | `spip.dirs.var` | `local/` |
| `getTmpDir()` | `spip.dirs.tmp` | `tmp/` (legacy SPIP, migrer à `var/`) |
| `getVarDir()` | — | `var/` (comme Symfony, remplace `tmp/`) |

## Chemins relatifs

```php
relative(string $cwd): SpipRelativeDirectories
```

`SpipRelativeDirectories` expose les mêmes getters (`getCoreDir()`, `getPluginsDir()`, …) en chemins
**relatifs au `$cwd`** passé (souvent `getcwd()`).

Alias déprécié : `getRootDir()` → `getProjectDir()`.

## Correspondance constantes legacy

| Constante | Source relative |
|-----------|-----------------|
| `_DIR_RACINE` | `relative($cwd)->getProjectDir()` |
| `_DIR_RESTREINT` | `relative($cwd)->getCoreDir()` |
| `_DIR_TMP` | `relative($cwd)->getTmpDir()` |
| `_DIR_VAR` | `relative($cwd)->getPublicAssetsDir()` |
| `_DIR_ETC` | `relative($cwd)->getConfigDir()` |
| `_DIR_PLUGINS` | `relative($cwd)->getPluginsDir()` |
| `_DIR_PLUGINS_DIST` | `relative($cwd)->getExtensionsDir()` |
| `_DIR_PLUGINS_SUPPL` | `relative($cwd)->getExtraPluginsDir()` (si `spip.dirs.extra_plugins` non vide) |
| `_ROOT_PLUGINS` | `getPluginsDir()` (absolu) |
| `_ROOT_PLUGINS_DIST` | `getExtensionsDir()` (absolu) |
| `_ROOT_PLUGINS_SUPPL` | `getExtraPluginsDir()` (absolu, si configuré) |
| `_DIR_IMG` | `relative($cwd)->getDocDir()` |
| `_FILE_OPTIONS` | absolu : `getConfigDir() . 'mes_options.php'` |

## Kernel — méthodes dépréciées

Les méthodes SPIP du `Kernel` (`getCoreDir()`, `relative()`, `getVarDir()`, …) délèguent à
`spip.directories` et émettent une dépréciation 5.0. Le Kernel conserve les méthodes Symfony :
`getProjectDir()`, `getCacheDir()`, `getBuildDir()`, `getShareDir()`, `getLogDir()`,
`getEnvironment()`, `isDebug()`.

## Voir aussi

- [Répertoires SPIP](../features/directories.md)
- [Environnement et Kernel](../guides/migration/environnement-kernel.md)
- [Paramètres `spip.*`](parametres-spip.md)
