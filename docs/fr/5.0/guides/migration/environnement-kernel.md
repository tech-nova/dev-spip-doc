# Environnement et Kernel

Le modèle est expliqué dans [Répertoires SPIP](../../features/directories.md) et
[Cycle applicatif HTTP](../../architecture/cycle-applicatif-http.md).

SPIP 5.0 introduit une gestion de l'environnement basée sur les standards Symfony.

## Variables d'environnement

Le bootstrap du kernel charge automatiquement les fichiers `.env` situés à la racine du projet via le composant `symfony/dotenv`. Les variantes suivantes sont reconnues
(par ordre de priorité) :

1. `.env.<APP_ENV>.local`
2. `.env.<APP_ENV>`
3. `.env.local`
4. `.env`

### Variables reconnues par le Kernel

| Variable | Description | Défaut |
| :--- | :--- | :--- |
| `APP_ENV` | Environnement d'exécution (`prod`, `dev`, `test`) | `prod` |
| `SPIP_CACHE_DIR` | Surcharge du répertoire de cache structurel | `tmp/cache/` |
| `SPIP_ETC_DIR` | Surcharge du répertoire de configuration | `config/` |

### Exemple de fichier `.env`

```env
APP_ENV=dev
# SPIP_CACHE_DIR=/var/spip/cache
# SPIP_ETC_DIR=/etc/spip
```

## Localisation des fichiers de configuration

La recherche d'un fichier `mes_options.php` dans le répertoire `ecrire/` n'est plus supportée.
Tous les fichiers de configuration personnalisés doivent impérativement se trouver dans le répertoire `config/` (ou le répertoire défini par `SPIP_ETC_DIR`).

- `config/mes_options.php` : pour les options historiques.
- `config/custom.php` : pour la nouvelle configuration via le conteneur de services Symfony.

## Répertoires : `Spip::directories()`

Remplacer progressivement les appels au Kernel pour les chemins :

| Avant (déprécié) | Après |
|------------------|-------|
| `app()->getRootDir()` | `Spip::directories()->getProjectDir()` |
| `app()->getEtcDir()` | `Spip::directories()->getConfigDir()` |
| `app()->getVarDir()` | `Spip::directories()->getPublicAssetsDir()` |
| `app()->relative()->getPluginsDir()` | `Spip::directories()->relative(getcwd())->getPluginsDir()` |

Le service `spip.directories` résout les chemins depuis `spip.dirs.*` et l'installation détectée.
Les constantes `_DIR_*` sont figées au boot et ne peuvent plus être redéfinies dans `options.php`.

Nommages à retenir :

- **`getPublicAssetsDir()`** : `local/` (ancien `_DIR_VAR`).
- **`getVarDir()`** : `var/` Symfony (anticipation migration P3).
- **`getDocDir()`** : fond documentaire `IMG/`.

Voir [Référence SpipDirectories](../../reference/spip-directories.md).

## Nettoyage des paramètres d'URI

Une configuration peu surchargée a été modifiée et renommée :

- introduction de la constante `_CONTEXTE_IGNORE_LISTE_VARIABLES` ;
- suppression de la constante `_CONTEXTE_IGNORE_VARIABLES`.

### Avant

```php
define('_CONTEXTE_IGNORE_VARIABLES', '/(^var_|^PHPSESSID$|^fbclid$|^utm_)/');
```

### Après

```php
define('_CONTEXTE_IGNORE_LISTE_VARIABLES', ['^var_', '^PHPSESSID$', '^fbclid$', '^utm_']);
```

## Voir aussi

- [Répertoires SPIP](../../features/directories.md)
- [Cycle applicatif HTTP](../../architecture/cycle-applicatif-http.md)
- [Référence SpipDirectories](../../reference/spip-directories.md)
