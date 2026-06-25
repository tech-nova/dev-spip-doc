# Répertoires SPIP (`spip.directories`)

SPIP 5.0 centralise la résolution des chemins du site dans le service **`spip.directories`**
(`SpipLeague\Component\Kernel\Directory\SpipDirectories`), distinct du **Kernel** qui converge vers le rôle
Symfony (boot, conteneur, environnement).

Mise en œuvre : [Environnement et Kernel](../guides/migration/environnement-kernel.md).
Signatures : [Référence SpipDirectories](../reference/spip-directories.md).

## En bref

- **Chemins absolus** : via `Spip::directories()->getCoreDir()`, `getPluginsDir()`, etc.
- **Chemins relatifs au cwd du hit** : via `Spip::directories()->relative()` — objet immuable, sans
  le fragile `app()->relative()->getX()` du Kernel historique.
- **Constantes legacy `_DIR_*`** : figées au boot par `LegacyDirectoryBootstrapper`, non surchargeables depuis
  `options.php` ni `mes_options.php` (seule `config/custom.php` peut surcharger les paramètres `spip.dirs.*`).

Extrait canonique :

```php
$dirs = Spip::directories();
$core = $dirs->getCoreDir();              // absolu : …/ecrire/
$rel = $dirs->relative();
$plugins = $rel->getPluginsDir();          // relatif : ../plugins/
```

## Trois familles de chemins

| Famille | Exemples | Surchargeable via `config/custom.php` |
|---------|----------|---------------------------------------|
| Racines SPIP | `getDocDir()` (IMG/), `getTmpDir()` (tmp/), `getPublicAssetsDir()` (local/) | Oui (`spip.dirs.*`) |
| Dérivés internes | `_DIR_CACHE`, `_DIR_IMG_ICONES`, `_CACHE_PLUGINS_*` | Non (calculés) |
| Symfony (anticipés) | `getVarDir()` (var/), `getCacheDir()`, `getLogDir()` | Partiellement |

!!! note "Surcharges"
    Il faudra déterminer plus en détail quels répertoires doivent ou non être surchargeables,
    via param, ou via ENV, et utiliser les mêmes nommages que symfony.

## Nommages importants

- **`getDocDir()`** : fond documentaire `IMG/` (`spip.dirs.doc`).
- **`getPublicAssetsDir()`** : assets publics générés `local/` — correspond à l’ancien `_DIR_VAR`.
- **`getVarDir()`** : répertoire Symfony `var/` (cache, log, state).
- **`getConfigDir()`** : remplace `getEtcDir()` ; surcharge possible via `SPIP_ETC_DIR`.

Les méthodes `getCoreDir()`, `getPluginsDir()`, `relative()`, etc. sur **`Kernel`** et **`app()`** sont
**dépréciées** : utiliser `Spip::directories()`.

## Boot & conteneur

Au premier `Kernel::boot()` :

1. `initializeContainer()` charge ou compile le conteneur **avant** `handle()`.
2. Le manifeste plugins (`var/state/plugins.php`) indique les plugins actifs (pas de lecture BDD / metas).
3. `LegacyDirectoryBootstrapper` définit les constantes `_DIR_*` relatives au cwd.
4. `LegacyBootstrapper` charge ensuite `inc_version.php` (runtime seul).

Tous les listeners plugins sont présents dès le premier hit.

## Voir aussi

- [Cycle applicatif HTTP](../architecture/cycle-applicatif-http.md)
- [Environnement et Kernel](../guides/migration/environnement-kernel.md)
- [Paramètres `spip.*`](../reference/parametres-spip.md)
- [Référence SpipDirectories](../reference/spip-directories.md)
- [Façade Spip](acces-services-spip.md)
